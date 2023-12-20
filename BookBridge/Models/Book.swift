//
//  Book.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 20.11.2023.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

class Book: Identifiable, Codable, ObservableObject {
    var id: String?
    var title: String
    var author: String
    var genre: String?
    var userId: String
    var imageUrl: String?
    var isBorrowed: Bool
   // var imageDataString: String?

    // Base64 formatında resim string'i için yeni alan
    /*var imageData: Data? {
        if let imageDataString = imageDataString {
            return Data(base64Encoded: imageDataString)
        }
        return nil
    }*/

   /*us var image: UIImage? {
        if let data = imageData {
            return UIImage(data: data)
        }
        return nil
    }*/
    
    var testImageData: Data? {
        if author == "Mustafa" {
            // Eğer bir şart sağlanıyorsa, özel bir işlem yapılabilir
        }
        if let imageUrl = imageUrl, let imageData = Data(base64Encoded: imageUrl) {
            return imageData
        }
        return nil
    }

    var dictionary: [String: Any] {
        return [
            "id": id ?? "",
            "title": title,
            "author": author,
            "genre": genre ?? "",
            "userId": userId ?? "",
            "imageUrl": imageUrl ?? "",
            "isBorrowed": isBorrowed,
            //"imageDataString": imageDataString ?? ""
        ]
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case author
        case genre
        case userId
        case imageUrl
        case isBorrowed
       // case imageDataString
    }

    init(id: String? = nil, title: String, author: String, genre: String, userId: String? = nil, imageUrl: String? = nil, isBorrowed: Bool = false
        // ,imageDataString: String? = nil
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.genre = genre
        self.userId = userId ?? ""
        self.imageUrl = imageUrl
        self.isBorrowed = isBorrowed
        //self.imageDataString = imageDataString
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(author, forKey: .author)
        try container.encode(genre, forKey: .genre)
        try container.encode(userId, forKey: .userId)
        try container.encode(isBorrowed, forKey: .isBorrowed)
        try container.encode(imageUrl, forKey: .imageUrl)
       // try container.encode(imageDataString, forKey: .imageDataString)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        author = try container.decode(String.self, forKey: .author)
        genre = try container.decode(String.self, forKey: .genre)
        userId = try container.decode(String.self, forKey: .userId)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        isBorrowed = try container.decode(Bool.self, forKey: .isBorrowed)
       // imageDataString = try container.decode(String.self, forKey: .imageDataString)
    }
    
}

extension Book: Equatable {
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id
    }
}




