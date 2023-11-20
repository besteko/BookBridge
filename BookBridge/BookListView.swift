//
//  BookListView.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 20.11.2023.
//

import SwiftUI

struct BookListView: View {
    @ObservedObject var bookViewModel: BookViewModel

    var body: some View {
        VStack {
            SearchBar(searchText: $bookViewModel.searchText, placeholder: "Kitap Ara")

            List(bookViewModel.filteredBooks) { book in
                NavigationLink(destination: BookDetailView(book: book)) {
                    BookRowView(book: book)
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}




