//
//  BookRowView.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 20.11.2023.
//

import SwiftUI

struct BookRowView: View {
    var book: Book

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                Text(book.author)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(book.genre)
                .font(.subheadline)
                .foregroundColor(.blue)
        }
        .padding()
    }
}
