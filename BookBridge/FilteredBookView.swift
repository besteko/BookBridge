//
//  FilteredBookView.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 20.11.2023.
//

import SwiftUI

struct FilteredBooksView: View {
    @ObservedObject var bookViewModel: BookViewModel
    var selectedGenre: String

    var body: some View {
        VStack {
            SearchBar(searchText: $bookViewModel.searchText, placeholder: "Kitap Ara")

            List(bookViewModel.filteredBooks.filter { $0.genre == selectedGenre }) { book in
                NavigationLink(destination: BookDetailView(book: book)) {
                    BookRowView(book: book)
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarTitle("\(selectedGenre) Kitapları")
    }
}
