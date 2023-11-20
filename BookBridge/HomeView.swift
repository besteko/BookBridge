//
//  HomeView.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 20.11.2023.
//

import SwiftUI


struct HomeView: View {
    @ObservedObject var bookViewModel: BookViewModel

    var body: some View {
        NavigationView {
            VStack {
                // Rastgele kitapları göster
                Text("Rastgele Kitaplar")
                    .font(.title)

                BookListView(bookViewModel: bookViewModel)

                // Kitap türlerine göre filtrelenmiş kitapları göster
                ForEach(bookViewModel.genres, id: \.self) { genre in
                    NavigationLink(destination: FilteredBooksView(bookViewModel: bookViewModel, selectedGenre: genre)) {
                        Text("\(genre) Kitapları")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }

                // Kitap ekleme sayfasına yönlendirme
                NavigationLink(destination: AddBookView(bookViewModel: bookViewModel)) {
                    Text("Kitap Ekle")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            .navigationBarTitle("Ana Sayfa")
        }
    }
}
