//
//  BookUpdateView.swift
//  bitirmedeneme
//
//  Created by Beste Kocaoglu on 7.12.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookUpdateView: View {
    @Binding var isEditing: Bool
    @ObservedObject var bookViewModel: BookViewModel
    @State public var updatedTitle: String
    @State public var updatedAuthor: String
    @State public var updatedGenre: String
    @State public var updatedImageUrl: String
    @State public var updatedIsBorrowed: Bool
    //@State public var updatedImageDataString: String
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var isUpdateSuccessful = false
    @State var didSelectedBook = false
    @Binding var refreshID: UUID
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Yeni Başlık", text: $updatedTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Yeni Yazar", text: $updatedAuthor)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Yeni Tür", text: $updatedGenre)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    // Resim seçiciyi aç
                    isImagePickerPresented.toggle()
                }) {
                    HStack {
                        Image(systemName: "photo")
                        Text("Fotoğraf Seç")
                    }
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(selectedImage: $selectedImage, isPickerPresented: $isImagePickerPresented) { imageUrl in
                        // Seçilen resmin URL'sini güncelle
                        updatedImageUrl = imageUrl
                    } didSelectedImage: {
                        didSelectedBook = true
                    }

                }
                
                // Seçilen resmi göster
                if let selectedImage = selectedImage {
                    // ImagePicker'dan dönen resmi göster
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                } else {
                    if let book = bookViewModel.selectedBook, let imageUrl = book.imageUrl, !imageUrl.isEmpty {
                        WebImage(url: URL(string: imageUrl))
                            .resizable()
                            .indicator(.activity)
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
                
                
                Toggle("Ödünç Alındı mı?", isOn: $updatedIsBorrowed)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .padding()
                //Beste
                //TextField("Yeni Resim Data", text: $updatedImageDataString)
                //   .textFieldStyle(RoundedBorderTextFieldStyle())
                //  .padding()
                
                Button("Güncelle") {
                    if let book = bookViewModel.selectedBook {
                        
                        if let selectedImage = selectedImage, didSelectedBook {
                            bookViewModel.uploadImage(selectedImage) { imageUrl in
                                book.imageUrl = imageUrl
                                updatedImageUrl = imageUrl
                                bookViewModel.updateBookInfo(book: book, updatedTitle: updatedTitle, updatedAuthor: updatedAuthor, updatedGenre: updatedGenre, updatedImageUrl: updatedImageUrl, updatedIsBorrowed: updatedIsBorrowed, completion: { error in
                                    if let error = error {
                                        print("Güncelleme hatası: \(error.localizedDescription)")
                                    } else {
                                        // Güncelleme başarılı, isUpdateSuccessful'ı true yap
                                        refreshID = UUID()
                                        bookViewModel.selectedBook = book
                                        isUpdateSuccessful = true
                                    }
                                })
                            }
                        } else {
                            bookViewModel.updateBookInfo(book: book, updatedTitle: updatedTitle, updatedAuthor: updatedAuthor, updatedGenre: updatedGenre, updatedImageUrl: updatedImageUrl, updatedIsBorrowed: updatedIsBorrowed, completion: { error in
                                if let error = error {
                                    print("Güncelleme hatası: \(error.localizedDescription)")
                                } else {
                                    // Güncelleme başarılı, isUpdateSuccessful'ı true yap
                                    refreshID = UUID()
                                    bookViewModel.selectedBook = book
                                    isUpdateSuccessful = true
                                }
                            })
                        }
                        
                    }
                }

                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(15)
                .fullScreenCover(isPresented: $isUpdateSuccessful) {
                    NavigationView {
                        if let selectedBook = bookViewModel.selectedBook {
                            BookDetailView(isPresented: $isUpdateSuccessful, bookViewModel: BookViewModel(selectedBook: selectedBook))
                                .onDisappear {
                                    isUpdateSuccessful = false
                                }
                        }
                    }
                }

                
            }
            .onAppear {
                // View açıldığında güncellenmiş bilgileri, kitap nesnesinden al
                updatedTitle = bookViewModel.selectedBook?.title ?? ""
                updatedAuthor = bookViewModel.selectedBook?.author ?? ""
                updatedGenre = bookViewModel.selectedBook?.genre ?? ""
                updatedImageUrl = bookViewModel.selectedBook?.imageUrl ?? ""
                updatedIsBorrowed = bookViewModel.selectedBook?.isBorrowed ?? false
                //updatedImageDataString = bookViewModel.selectedBook?.imageDataString ?? ""
            }
            //.navigationTitle("Kitap Güncelle")
        }
    }
}









