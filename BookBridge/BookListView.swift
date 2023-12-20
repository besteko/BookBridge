//
//  BookListView.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 20.11.2023.
//

import SwiftUI


struct BookListView: View {
    @State private var isDetailViewPresented = false
    @ObservedObject var bookViewModel: BookViewModel

    init(bookViewModel: BookViewModel) {
        self.bookViewModel = bookViewModel
    }

    var body: some View {
        List(bookViewModel.books) { book in
            NavigationLink(destination: BookDetailView(isPresented: $isDetailViewPresented, bookViewModel: BookViewModel(selectedBook: book))) {
                BookRowView(book: book) {
                    removeBook(book)
                }
            }

        }
    }

    private func removeBook(_ book: Book) {
        bookViewModel.removeBook(bookID: book.id ?? "") { error in
            // Kitap kaldırıldıktan sonra yapılacak işlemler
            if error == nil {
                // Kitap başarıyla kaldırıldı, belki başka bir şey yapabilirsiniz
            }
        }
    }
}








