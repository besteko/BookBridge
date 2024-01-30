//
//  BorrowingManager.swift
//  bitirmedeneme
//
//  Created by Beste Kocaoglu on 3.01.2024.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

class BorrowingManager: ObservableObject {
    @Published var isBorrowingConfirmed = false
    @Published var lentBooks: [BorrowedBook] = []

   /* func borrowBook(book: Book, selectedDurationIndex: Int, address: String, selectedDate: Date) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let borrowedBook = BorrowedBook(
            id: book.id ?? "",
            bookId: book.id ?? "",
            userId: userId,
            borrowedDate: selectedDate,
            returnDate: Calendar.current.date(byAdding: .weekOfYear, value: selectedDurationIndex + 1, to: selectedDate) ?? selectedDate,
            title: book.title,
            author: book.author
        )

        saveBorrowedBook(borrowedBook: borrowedBook)
        isBorrowingConfirmed = true
    }*/
    
    func borrowBook(book: Book, selectedDurationIndex: Int, address: String, selectedDate: Date) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let borrowedBook = BorrowedBook(
            id: book.id ?? "",
            bookId: book.id ?? "",
            userId: userId,
            borrowedDate: selectedDate,
            returnDate: Calendar.current.date(byAdding: .weekOfYear, value: selectedDurationIndex + 1, to: selectedDate) ?? selectedDate,
            title: book.title,
            author: book.author
        )

        saveBorrowedBook(borrowedBook: borrowedBook)
        isBorrowingConfirmed = true

        // Kitabın durumunu güncelle
        updateBookBorrowStatus(bookId: book.id ?? "", isBorrowed: true) { error in
            if let error = error {
                print("Kitap durumu güncellenemedi: \(error.localizedDescription)")
            } else {
                print("Kitap başarıyla ödünç alındı!")
            }
        }
    }

    func updateBookBorrowStatus(bookId: String, isBorrowed: Bool, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let dbRef = Database.database().reference().child("users").child(userId).child("books").child(bookId)
        let updateData: [String: Any] = [
            "isBorrowed": isBorrowed
        ]

        dbRef.setValue(updateData) { error, _ in
            completion(error)
        }
    }


    
    func lendBook(bookId: String, borrowedUserId: String, borrowedDate: Date, returnDate: Date) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let dbRef = Database.database().reference().child("users").child(userId).child("lentBooks")
        let newLentBookRef = dbRef.childByAutoId() // Benzersiz bir ID oluşturun

        let lentBook = BorrowedBook(
            id: newLentBookRef.key ?? "", // Benzersiz ID'yi kullanabilirsiniz
            bookId: bookId,
            userId: borrowedUserId,
            borrowedDate: borrowedDate,
            returnDate: returnDate,
            title: "Kitap Başlığı", // Kitap başlığını doldurun
            author: "Yazar" // Yazarı doldurun
        )

        do {
            // BorrowedBook nesnesini Firebase'e eklemek için [String: Any] sözlüğe çevirme
            let lentBookData = try JSONEncoder().encode(lentBook)
            guard let lentBookDictionary = try JSONSerialization.jsonObject(with: lentBookData, options: []) as? [String: Any] else {
                return
            }

            // Firebase'e veriyi ekleme
            newLentBookRef.setValue(lentBookDictionary) { (error, _) in
                if let error = error {
                    print("Kitap ödünç verilemedi: \(error.localizedDescription)")
                } else {
                    print("Kitap başarıyla ödünç verildi")
                }
            }
        } catch {
            print("Kitap verisi çevrilemedi: \(error.localizedDescription)")
        }
    }


    func saveBorrowedBook(borrowedBook: BorrowedBook) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let dbRef = Database.database().reference().child("users").child(userId).child("borrowedBooks").child(borrowedBook.id ?? "")
        let borrowedBookData: [String: Any] = [
            "id": borrowedBook.id ?? "",
            "bookId": borrowedBook.bookId,
            "userId": borrowedBook.userId,
            "borrowedDate": borrowedBook.borrowedDate.timeIntervalSince1970,
            "returnDate": borrowedBook.returnDate.timeIntervalSince1970,
            "title": borrowedBook.title,
            "author": borrowedBook.author
        ]

        dbRef.setValue(borrowedBookData) { error, _ in
            if let error = error {
                print("Kitap ödünç alınırken hata oluştu: \(error)")
            } else {
                print("Kitap başarıyla ödünç alındı!")
            }
        }
    }

    func fetchBorrowedBooks(completionHandler: @escaping (_ books:[BorrowedBook]) -> Void ) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let dbRef = Database.database().reference().child("users").child(userId).child("borrowedBooks")

        dbRef.observe(.value) { snapshot in
            var books: [BorrowedBook] = []

            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let data = snapshot.value as? [String: Any],
                   let bookData = try? JSONSerialization.data(withJSONObject: data),
                   let decodedBook = try? JSONDecoder().decode(BorrowedBook.self, from: bookData) {
                    books.append(decodedBook)
                }
            }

            // Güncellenen kitap listesini yerel değişkene ata
//            self.borrowedBooks = books
            completionHandler(books)
        }
    }

    func fetchLentBooks(completionHandler: @escaping (_ books: [BorrowedBook]) -> Void) {
            guard let userId = Auth.auth().currentUser?.uid else {
                return
            }

            let dbRef = Database.database().reference().child("users").child(userId).child("lentBooks")

            dbRef.observe(.value) { snapshot in
                var books: [BorrowedBook] = []

                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                       let data = snapshot.value as? [String: Any],
                       let bookData = try? JSONSerialization.data(withJSONObject: data),
                       let decodedBook = try? JSONDecoder().decode(BorrowedBook.self, from: bookData) {
                        books.append(decodedBook)
                    }
                }

                // Güncellenen kitap listesini yerel değişkene ata
                self.lentBooks = books
                completionHandler(books)

                print("fetchLentBooks - Lent Books: \(self.lentBooks)")
            }
        }
    }

    


