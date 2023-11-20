//
//  BookViewModel.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 20.11.2023.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth


class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var filteredBooks: [Book] = []
    @Published var searchText: String = ""
    @Published var genres: [String] = []

    private var db = Firestore.firestore()

    func fetchBooks(forUserId userId: String) {
        db.collection("books").whereField("userId", isEqualTo: userId).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Hata: \(error?.localizedDescription ?? "Bilinmeyen bir hata oluştu.")")
                return
            }

            self.books = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Book.self)
            }

            // Tüm kitap türlerini al
            self.genres = Array(Set(self.books.map { $0.genre }))

            // Kitapları filtrele
            self.filterBooks()
        }
    }

    func addBook(book: Book, completion: @escaping (Error?) -> Void) {
        do {
            var mutableBook = book
            mutableBook.userId = Auth.auth().currentUser?.uid

            let _ = try? db.collection("books").addDocument(data: mutableBook.dictionary) { error in
                completion(error)
                if let error = error {
                    print("Hata: \(error.localizedDescription)")
                } else {
                    print("Kitap eklendi")
                }
            }
        } catch {
            print("Hata: \(error.localizedDescription)")
            completion(error)
        }
    }




    func filterBooks() {
        if searchText.isEmpty {
            filteredBooks = books
        } else {
            filteredBooks = books.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.author.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
