//
//  BorrowedBook.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 30.01.2024.
//

import Foundation
import SwiftUI
import Firebase

class BorrowedBook: Identifiable, Codable, ObservableObject {
    var id: String?
    var bookId: String
    var userId: String
    var borrowedDate: Date
    var returnDate: Date
    var title: String
    var author: String

    var dictionary: [String: Any] {
        return [
            "id": id ?? "",
            "bookId": bookId,
            "userId": userId,
            "borrowedDate": borrowedDate.timeIntervalSince1970,
            "returnDate": returnDate.timeIntervalSince1970,
            "title": title,
            "author": author
        ]
    }

    enum CodingKeys: String, CodingKey {
        case id
        case bookId
        case userId
        case borrowedDate
        case returnDate
        case title
        case author
    }

    init(id: String? = nil, bookId: String, userId: String, borrowedDate: Date, returnDate: Date, title: String, author: String) {
        self.id = id
        self.bookId = bookId
        self.userId = userId
        self.borrowedDate = borrowedDate
        self.returnDate = returnDate
        self.title = title
        self.author = author
    }


    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(bookId, forKey: .bookId)
        try container.encode(userId, forKey: .userId)
        try container.encode(borrowedDate, forKey: .borrowedDate)
        try container.encode(returnDate, forKey: .returnDate)
        try container.encode(title, forKey: .title)
        try container.encode(author, forKey: .author)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        bookId = try container.decode(String.self, forKey: .bookId)
        userId = try container.decode(String.self, forKey: .userId)
        borrowedDate = try container.decode(Date.self, forKey: .borrowedDate)
        returnDate = try container.decode(Date.self, forKey: .returnDate)
        title = try container.decode(String.self, forKey: .title)
        author = try container.decode(String.self, forKey: .author)
    }
    
}
