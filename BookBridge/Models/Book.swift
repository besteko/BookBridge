//
//  Book.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 20.11.2023.
//

import Foundation
import Firebase

struct Book: Identifiable, Codable {
    var id: String?
    var title: String
    var author: String
    var genre: String
    var userId: String?

    var dictionary: [String: Any] {
        return [
            "id": id ?? "",
            "title": title,
            "author": author,
            "genre": genre,
            "userId": userId ?? ""
        ]
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case author
        case genre
        case userId
    }

    init(id: String? = nil, title: String, author: String, genre: String, userId: String? = nil) {
        self.id = id
        self.title = title
        self.author = author
        self.genre = genre
        self.userId = userId
    }
}

extension Book: Equatable {
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id
    }
}
