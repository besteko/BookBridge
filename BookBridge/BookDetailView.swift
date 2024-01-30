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
    @State private var refreshID = UUID()
    @State private var isBorrowBookViewPresented = false

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

                Text(bookViewModel.selectedBook?.isBorrowed ?? false ? "Ödünç Alındı" : "Müsait")
                    .foregroundColor(bookViewModel.selectedBook?.isBorrowed ?? false ? .red : .green)
                    .font(.headline)
                    .bold()
                    .padding()

                if let currentUser = Auth.auth().currentUser, let book = bookViewModel.selectedBook {
                    if book.userId == currentUser.uid {
                        // Bu kullanıcı kitap sahibi ise
                        Button(action: {
                            isEditing.toggle()
                        }) {
                            Text("Kitap Bilgilerini Güncelle")
                                .padding()
                                .foregroundColor(.white)
                                .font(.headline)
                                .background(Color.blue)
                                .cornerRadius(15)
                        }
                        .padding(.bottom, 20)
                    } else {
                        // Bu kullanıcı kitap sahibi değilse
                        if book.isBorrowed {
                            // Kitap ödünç alınmışsa, İade Et butonu veya "Kitap Müsait Değil" mesajını göster
                            if book.userId == Auth.auth().currentUser?.uid {
                                // Bu kullanıcı kitabı ödünç almışsa, İade Et butonunu göster
                                Button(action: {
                                    bookViewModel.returnBook(book: book) { error in
                                        if let error = error {
                                            print("Kitap iade edilemedi: \(error.localizedDescription)")
                                        } else {
                                            print("Kitap başarıyla iade edildi")
                                        }
                                    }
                                }) {
                                    Text("İade Et")
                                        .padding()
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .background(Color.red)
                                        .cornerRadius(15)
                                }
                                .padding(.bottom, 20)
                            } else {
                                // Başka bir kullanıcı kitabı ödünç almışsa, "Kitap Müsait Değil" mesajını göster
                                Text("Kitap Müsait Değil")
                                    .foregroundColor(.red)
                                    .font(.headline)
                                    .bold()
                                    .padding(.bottom, 20)
                            }
                        } else {
                            // Kitap ödünç alınmamışsa, Ödünç Al butonunu göster
                            Button(action: {
                                isBorrowBookViewPresented = true
                            }) {
                                Text("Ödünç Al")
                                    .padding()
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .background(Color.green)
                                    .cornerRadius(15)
                            }
                            .padding(.bottom, 20)
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $isBorrowBookViewPresented) {
            BookBorrowingView(isPresented: $isBorrowBookViewPresented, borrowingManager: BorrowingManager(), bookViewModel: bookViewModel)
        }
    }
}

