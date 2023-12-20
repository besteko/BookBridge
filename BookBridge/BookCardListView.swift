//
//  BookCardListView.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 29.11.2023.
//
import SwiftUI
import SDWebImageSwiftUI

struct Card: View {
    var book: Book

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageUrl = book.imageUrl, !imageUrl.isEmpty {
                WebImage(url: URL(string: imageUrl))
                    .resizable()
                    .placeholder(Image("book_placeholder")) // Placeholder görsel
                    .indicator(.activity) // Activity Indicator
                    .transition(.fade(duration: 0.5)) // Fade Transition with duration
                    .scaledToFill()
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(10)
            } else {
                Image(systemName: "book")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(10)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(book.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(book.genre!)
                    .font(.subheadline)
                    .foregroundColor(.brown)
            }
            .padding(.horizontal, 8) // Metinlere yatay iç boşluk ekleyin

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct BookCardListView: View {
    @State private var isDetailViewPresented = false
    @ObservedObject var bookViewModel: BookViewModel
    @Binding var searchText: String
    

    var body: some View {
        VStack {
            //SearchBar(searchText: $searchText, placeholder: "Kitap Ara", onCommit: <#() -> Void#>)

            List(filterBooks()) { book in
                NavigationLink(destination: BookDetailView(isPresented: $isDetailViewPresented, bookViewModel: BookViewModel(selectedBook: book))) {
                    Card(book: book)
                }                .buttonStyle(PlainButtonStyle())
            }
            .listStyle(PlainListStyle())

        }
        .padding(.horizontal)
    }

    private func filterBooks() -> [Book] {
        if searchText.isEmpty {
            return bookViewModel.books
        } else {
            return bookViewModel.books.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.author.localizedCaseInsensitiveContains(searchText) ||
                (($0.genre?.localizedCaseInsensitiveContains(searchText)) != nil)
            }
        }
    }
}
