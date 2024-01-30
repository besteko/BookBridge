//
//  AvatarGalleryView.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 30.01.2024.
//

import SwiftUI

struct AvatarGalleryView: View {
    let avatars: [String]
    var didSelectAvatar: (String) -> Void

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
                ForEach(avatars, id: \.self) { avatar in
                    Image(avatar)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .onTapGesture {
                            didSelectAvatar(avatar)
                        }
                }
            }
            .padding()
        }
    }
}
