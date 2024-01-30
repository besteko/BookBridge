//
//  FiltretedBooksView.swift
//  bitirmedeneme
//
//  Created by Beste Kocaoglu on 18.11.2023.
//

import SwiftUI

struct FilteredBooksView: View {
    @State private var isDetailViewPresented = false
    @ObservedObject var bookViewModel: BookViewModel
    var selectedGenre: String

    @State private var searchText = "" // Added state for searchText
    @State private var filteredBooks: [Book] = [] // Added state for filteredBooks

    var body: some View {
        VStack {
            SearchBar(searchText: $searchText, placeholder: "Kitap Ara", onCommit: filterBooks)

            List(filteredBooks) { book in
                NavigationLink(destination: BookDetailView(isPresented: $isDetailViewPresented, bookViewModel: BookViewModel(selectedBook: book))){
                    BookRowView(book: book) {
                        removeBook(book)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarTitle("\(selectedGenre) Kitapları")
    }

    private func removeBook(_ book: Book) {
        bookViewModel.removeBook(bookID: book.id ?? "") { error in
            // Kitap kaldırıldıktan sonra yapılacak işlemler
            if error == nil {
                // Kitap başarıyla kaldırıldı, belki başka bir şey yapabilirsiniz
            }
        }
    }

    private func filterBooks() {
        // Filter the books based on genre and search text
        let genreFilteredBooks = bookViewModel.books.filter { $0.genre == selectedGenre }
        if searchText.isEmpty {
            filteredBooks = genreFilteredBooks
        } else {
            filteredBooks = genreFilteredBooks.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
}







