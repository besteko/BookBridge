//
//  AddBookView.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 20.11.2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

struct AddBookView: View {
    @ObservedObject var bookViewModel: BookViewModel
    @State private var title = ""
    @State private var author = ""
    @State private var genre = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
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

                Button(action: {
                    addBook()
                }) {
                    Text("Kitap Ekle")
                }
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Hata"), message: Text("Kitap eklenirken bir hata oluştu."), dismissButton: .default(Text("Tamam")))
                }
                .navigationTitle("Kitap Ekle")
            }
        }
    }

    func addBook() {
        let newBook = Book(title: title, author: author, genre: genre)
        bookViewModel.addBook(book: newBook) { error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                showingAlert = true
            } else {
                print("Kitap başarıyla eklendi")
                // Kitap başarıyla eklendi, ana sayfaya geri dön
                bookViewModel.fetchBooks(forUserId: Auth.auth().currentUser?.uid ?? "")
            }
        }
    }
}
