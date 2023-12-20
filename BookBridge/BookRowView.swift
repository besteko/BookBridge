//
//  BookRowView.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 20.11.2023.
//



import SwiftUI
import SDWebImageSwiftUI

struct BookRowView: View {
    var book: Book
    var removeBookAction: () -> Void   // Yeni eklenen satır

    var body: some View {
        HStack{
           /* if let imageDataString = book.imageDataString,
               let imageData = Data(base64Encoded: imageDataString),
               let uiImage = UIImage(data: imageData) {

                // UIKit'ten SwiftUI'ye dönüşüm
                let swiftUIImage = Image(uiImage: uiImage)

                // Oluşturulan SwiftUI Image'i kullanın
                swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
            } else {
                // Eğer imageDataString boş veya hatalı ise, varsayılan sistem kitap ikonunu kullanın
                Image("book")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
            } */
            if let imageUrl = book.imageUrl, !imageUrl.isEmpty {
                WebImage(url: URL(string: imageUrl))
                    .resizable()
                    .placeholder(Image("book_placeholder")) // Placeholder görsel
                    .indicator(.activity) // Activity Indicator
                    .transition(.fade(duration: 0.5)) // Fade Transition with duration
                    .scaledToFill()
                    .frame(width: 80, height: 80) // Kare bir frame belirleyin
                    .clipShape(Circle()) // Daire şeklinde kesme işlemi
                    .overlay(Circle().stroke(Color.white, lineWidth: 4)) // Beyaz bir kenarlık ekleyin
                    .shadow(radius: 7) // Gölge ekleyin

            } else {
                Image(systemName: "book")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                    .foregroundColor(.brown)
                Text(book.author)
                    .font(.subheadline)
                    .foregroundColor(.brown)
            }

            Spacer()

            Button(action: {
                removeBookAction()  // Yeni eklenen satır
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.orange)
            }
        }
        .padding(.vertical, 8)
    }
}







