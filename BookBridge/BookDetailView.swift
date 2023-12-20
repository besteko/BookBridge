//
//  BookDetailView.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 20.11.2023.
//


import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth

struct BookDetailView: View {
    @Binding var isPresented: Bool
    @ObservedObject var bookViewModel: BookViewModel
    @State private var isEditing = false
    @State private var updatedTitle = ""
    @State private var updatedAuthor = ""
    @State private var updatedImageUrl = ""
    @State private var updatedGenre = ""
    @State private var updatedIsBorrowed = false
   // @State private var updatedImageDataString = ""
    @State private var refreshID = UUID()

    var body: some View {
        ZStack {
            Color(red: 1.2, green: 1.1, blue: 0.9)
                .edgesIgnoringSafeArea(.all)

            VStack {
                if let book = bookViewModel.selectedBook, let imageUrl = book.imageUrl, !imageUrl.isEmpty {
                    WebImage(url: URL(string: imageUrl))
                        .resizable()
                        .placeholder(Image("book"))
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom, 20)
                } else {
                    Image(systemName: "book")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom, 20)
                }

                Text(bookViewModel.selectedBook?.title ?? "")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 5)
                    .foregroundColor(.brown)

                Text("Yazar: \(bookViewModel.selectedBook?.author ?? "")")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 10)

                Text( (bookViewModel.selectedBook?.isBorrowed ?? false) ? "Ödünç Alındı" : "Müsait")
                    .foregroundColor( (bookViewModel.selectedBook?.isBorrowed ?? false) ? .red : .green)
                    .font(.headline)
                    .bold()
                    .padding()

                if let currentUser = Auth.auth().currentUser, let book = bookViewModel.selectedBook, book.userId != currentUser.uid {
                    Button(action: {
                        if let book = bookViewModel.selectedBook, book.isBorrowed {
                            bookViewModel.returnBook(book: book) { error in
                                if let error = error {
                                    print("Kitap iade edilemedi: \(error.localizedDescription)")
                                } else {
                                    print("Kitap başarıyla iade edildi")
                                }
                            }
                        } else {
                            // Ödünç alma işlemleri burada yapılabilir
                        }
                    }) {
                        Text( (bookViewModel.selectedBook?.isBorrowed ?? false) ? "İade Et" : "Ödünç Al")
                            .padding()
                            .foregroundColor(.white)
                            .font(.headline)
                            .background( (bookViewModel.selectedBook?.isBorrowed ?? false) ? Color.red : Color.green)
                            .cornerRadius(15)
                    }
                    .padding(.bottom, 20)
                } else {
                    Button(action: {
                        isEditing.toggle()
                    }) {
                        NavigationLink(
                            destination: BookUpdateView(
                                isEditing: $isEditing,
                                bookViewModel: bookViewModel,
                                updatedTitle: updatedTitle,
                                updatedAuthor: updatedAuthor,
                                updatedGenre: updatedGenre,
                                updatedImageUrl: updatedImageUrl,
                                updatedIsBorrowed: updatedIsBorrowed,
                               // updatedImageDataString: updatedImageDataString,
                                refreshID: $refreshID
                            ),
                            isActive: $isEditing

                        ) {
                            Text("Kitap Bilgilerini Güncelle")
                                .padding()
                                .foregroundColor(.white)
                                .font(.headline)
                                .background(Color.blue)
                                .cornerRadius(15)
                        }
                    }
                }

                Spacer()
            }
            .padding()
           // .navigationBarTitle(bookViewModel.selectedBook.title ?? "")
        }
    }
}

