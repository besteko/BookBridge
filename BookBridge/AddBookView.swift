//
//  AddBookView.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 20.11.2023.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

struct AddBookView: View {
    
    @StateObject var bookViewModel: BookViewModel
    
    init(bookViewModel: BookViewModel) {
        _bookViewModel = StateObject(wrappedValue: bookViewModel)
    }
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre = ""
    @State private var selectedImage: UIImage?
    @State private var selectedImageUrl: String?
    @State private var isImagePickerPresented = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isBookAdded = false  // Yeni eklenen satır
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 1.2, green: 1.1, blue: 0.9)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image("addbooktab")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding()
                    
                    VStack {
                        TextField("Kitap Adı", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        TextField("Yazar", text: $author)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        TextField("Tür", text: $genre)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
                    
                    Button(action: {
                        isImagePickerPresented.toggle()
                    }) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Kitap Fotoğrafı Seç")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(selectedImage: $selectedImage, isPickerPresented: $isImagePickerPresented) { selectedImageUrl in
                            self.selectedImageUrl = selectedImageUrl
                        }
                    }
                    
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(8)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button("Kitabı Ekle") {
                        addBook()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(8)
                    .padding(.bottom, 30)  // "Kitabı Ekle" butonu alt boşluk ekleyin
                }
                .padding()
                .foregroundColor(.black)
                //.navigationBarTitle("Kitap Ekle", displayMode: .inline)
            }
        }
        
    }
    
    
    private func addBook() {
        guard !title.isEmpty, !author.isEmpty, !genre.isEmpty else {
            showAlert(message: "Lütfen tüm kitap bilgilerini girin.")
            return
        }
        
        guard selectedImage != nil else {
            showAlert(message: "Lütfen bir kitap fotoğrafı seçin.")
            return
        }
        
        guard let currentUser = Auth.auth().currentUser else {
            showAlert(message: "Kullanıcı oturumu açmamış.")
            return
        }
        
        // Yeni eklenen satır
        isBookAdded = true
        
        // Kullanıcının ID'sini al
        let userID = currentUser.uid
        
        var newBook = Book(
            title: title,
            author: author,
            genre: genre,
            userId: userID,
            imageUrl: selectedImageUrl,
            isBorrowed: false
        )
        
        if let selectedImage = selectedImage {
            bookViewModel.uploadImage(selectedImage) { imageUrl in
                newBook.imageUrl = imageUrl
                self.addBook(newBook: newBook)
            }
        } else {
            self.addBook(newBook: newBook)
        }
    }
    
    private func addBook(newBook: Book) {
        bookViewModel.addBook(book: newBook) { (error) in
            // Yeni eklenen satır
            isBookAdded = false
            
            if let error = error {
                print("ViewModel'a kitap ekleme hatası: \(error.localizedDescription)")
                showAlert(message: "Kitap eklenirken bir hata oluştu.")
            } else {
                // Kitap başarıyla ViewModel'a eklendi
                showAlert(message: "Kitap başarıyla eklendi.")
                resetForm() // Formu sıfırla
            }
        }
    }
    
    private func resetForm() {
        // Formdaki değerleri sıfırla
        title = ""
        author = ""
        genre = ""
        selectedImage = nil
    }
    
    // showAlert fonksiyonunu tanımla
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}
