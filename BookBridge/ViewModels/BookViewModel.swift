//
//  BookViewModel.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 20.11.2023.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var selectedBook: Book?
    @Published private(set) var genres: [String] = []
    @Published private(set) var filteredBooks: [Book] = []
    
    private var dbRef: DatabaseReference?
    
    init(selectedBook: Book? = nil) {
        configureDatabase()
        fetchBooks()
        self.selectedBook = selectedBook
    }
    
    private func configureDatabase() {
        dbRef = Database.database().reference().child("books")
    }
    
    private func fetchBooks() {
        dbRef?.observe(.value, with: { [weak self] snapshot in
            var newBooks: [Book] = []
            var newGenres: [String] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let data = snapshot.value as? [String: Any],
                   let bookData = try? JSONSerialization.data(withJSONObject: data),
                   let decodedBook = try? JSONDecoder().decode(Book.self, from: bookData) {
                    newBooks.append(decodedBook)
                    
                    // Kitap türünü genres listesine ekle
                    if let genre = decodedBook.genre,
                       !genre.isEmpty {
                        newGenres.append(contentsOf: genre.components(separatedBy: ", "))
                    }
                }
            }
            
            self?.books = newBooks
            self?.genres = Array(Set(newGenres.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) })) // Duplicates'ları temizle
        })
    }
    
    func addBook(book: Book, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid, let dbRef = self.dbRef  else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı oturumu açmamış."])
            completion(error)
            return
        }
        
        let bookRef = dbRef.childByAutoId()
        var updatedBook = book
        let bookID = bookRef.key
        updatedBook.userId = userId
        updatedBook.id = bookID
        
        
        bookRef.setValue(updatedBook.dictionary) { (error, _) in
            completion(error)
        }
    }
    
    /*func updateBookImageUrl(book: Book, updatedImageUrl: String) {
            if let userID = Auth.auth().currentUser?.uid {
                let bookRef = Database.database().reference().child("users").child(userID).child("books").child(book.id!)

                bookRef.updateChildValues(["imageUrl": updatedImageUrl]) { (error, ref) in
                    if let error = error {
                        print("URL güncelleme hatası: \(error.localizedDescription)")
                    } else {
                        print("URL başarıyla güncellendi.")
                    }
                }
            }
        }*/
    
    func removeBook(bookID: String, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı oturumu açmamış."])
            completion(error)
            return
        }
        
        let bookRef = dbRef?.child(bookID)
        bookRef?.removeValue { (error, _) in
            completion(error)
        }
    }
    
    func returnBook(book: Book, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı oturumu açmamış."])
            completion(error)
            return
        }
        
        guard let updatedBookIndex = books.firstIndex(where: { $0.id == book.id }) else {
            let error = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Kitap bulunamadı."])
            completion(error)
            return
        }
        
        // İade işlemlerini burada gerçekleştirin
        // Örneğin: books[updatedBookIndex].isBorrowed = false
        
        // Güncellenmiş kitabı Firebase veritabanına yazma
        let bookRef = dbRef?.child(book.id ?? "")
        bookRef?.setValue(books[updatedBookIndex].dictionary) { (error, _) in
            completion(error)
        }
    }
    
    func uploadImage(_ image: UIImage, completionHandler: ((String) -> ())? ) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Resim verisi oluşturulamadı.")
            return
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        if let user = Auth.auth().currentUser {
            let userUID = user.uid
            let imageRef = storageRef.child("images/\(userUID)/\(UUID().uuidString).jpg")
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let _ = imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Yükleme hatası: \(error.localizedDescription)")
                } else {
                    imageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            if let error = error {
                                print("URL alınamadı: \(error.localizedDescription)")
                            }
                            return
                        }
                        print("Dosya URL'si: \(downloadURL)")
                        completionHandler?(downloadURL.absoluteString)
                    }
                }
            }
        }
    }
    
    func filterBooks(with searchText: String) -> [Book] {
        if searchText.isEmpty {
            
            return books
        } else {
            return books.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.author.localizedCaseInsensitiveContains(searchText) ||
                ($0.genre?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
   func updateBookInfo(
        book: Book,
        updatedTitle: String,
        updatedAuthor: String,
        updatedGenre: String?,
        updatedImageUrl: String,
        updatedIsBorrowed: Bool,
        completion: @escaping (Error?) -> Void
    ) {
        guard (Auth.auth().currentUser?.uid) != nil else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı oturumu açmamış."])
            completion(error)
            return
        }

        // Güncellenmiş kitabın veritabanındaki referansını bul
        guard let bookRef = dbRef?.child(book.id ?? "") else {
            let error = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Kitap bulunamadı."])
            completion(error)
            return
        }

        // Güncellenecek alanları belirle
        var updatedFields: [String: Any] = [
            "title": updatedTitle,
            "author": updatedAuthor,
            "imageUrl": updatedImageUrl,
            "isBorrowed": updatedIsBorrowed
        ]

        // Optional genre'yi ekleyin, eğer değeri varsa
        if let updatedGenre = updatedGenre {
            updatedFields["genre"] = updatedGenre
        }

        // Belirtilen alanları güncelle
        bookRef.updateChildValues(updatedFields) { (error, _) in
            completion(error)
        }
    }



     
     }
    





