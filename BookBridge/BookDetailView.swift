//
//  BookDetailView.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 20.11.2023.
//

import SwiftUI

struct BookDetailView: View {
    var book: Book

    var body: some View {
        VStack(alignment: .leading) {
            Text(book.title)
                .font(.title)
                .padding(.bottom, 5)

            Text("Yazar: \(book.author)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 10)

            Text("Tür: \(book.genre)")
                .font(.subheadline)
                .foregroundColor(.blue)
                .padding(.bottom, 10)

            Spacer()

            // Buraya kitabın diğer detayları eklenebilir.

        }
        .padding()
        .navigationBarTitle(Text(book.title), displayMode: .inline)
    }
}
