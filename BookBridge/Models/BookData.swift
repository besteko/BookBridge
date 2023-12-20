//
//  BookData.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 29.11.2023.
//

import Foundation

struct BookData: Codable {
    var title: String
    var author: String
    var genre: String
    var isBorrowed: Bool
   // var imageDataString: String?

    init(book: Book) {
        self.title = book.title
        self.author = book.author
        self.genre = book.genre ?? "Default Genre"
        self.isBorrowed = book.isBorrowed
       // self.imageDataString = book.imageUrl
    }

    var dictionaryRepresentation: [String: Any] {
        return [
            "title": title,
            "author": author,
            "genre": genre,
            "isBorrowed": isBorrowed,
            //"imageUrl": imageDataString ?? ""
        ]
    }
}
