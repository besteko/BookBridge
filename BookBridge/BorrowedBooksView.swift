//
//  BorrowedBooksView.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 29.11.2023.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct BorrowedBooksView: View {
    @ObservedObject var bookViewModel: BookViewModel

    // Assuming BorrowedBooksView expects a BookViewModel instance
    init(bookViewModel: BookViewModel) {
        self.bookViewModel = bookViewModel
    }

    @State private var borrowedBooks: [Book] = []

    var body: some View {
        VStack {
            List(borrowedBooks) { book in
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.headline)
                    Text(book.author)
                        .font(.subheadline)
                    // Diğer kitap bilgilerini ekleyebilirsiniz
                }
            }
            .onAppear {
                fetchBorrowedBooks()
            }
        }
    }

    func fetchBorrowedBooks() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let dbRef = Database.database().reference().child("users").child(userId).child("books")

        dbRef.queryOrdered(byChild: "isBorrowed").queryEqual(toValue: true).observe(.value) { snapshot in
            var books: [Book] = []

            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let data = snapshot.value as? [String: Any],
                   let bookData = try? JSONSerialization.data(withJSONObject: data),
                   let decodedBook = try? JSONDecoder().decode(Book.self, from: bookData) {
                    books.append(decodedBook)
                }
            }

            borrowedBooks = books
        }
    }
}

struct BorrowedBooksView_Previews: PreviewProvider {
    static var previews: some View {
        BorrowedBooksView(bookViewModel: BookViewModel()) // BookViewModel örneği ekleyin
    }
}

