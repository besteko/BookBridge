//
//  FirebaseImageView.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 29.11.2023.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct FirebaseImageView: View {
    var imageURL: String

    var body: some View {
        WebImage(url: URL(string: imageURL))
            .resizable()
            .indicator(.activity) // SDWebImageSwiftUI'nin yüklenme göstergesi
            .scaledToFit()
            .frame(height: 50)
            .cornerRadius(5)
    }
}
