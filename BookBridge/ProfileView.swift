//
//  ProfileView.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 29.11.2023.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ProfileView: View {
    @State private var isDetailViewPresented = false
    @ObservedObject var bookViewModel: BookViewModel
    @State private var user: User?
    @State private var isLoggedOut = false

    var body: some View {
        VStack {
            if let user = user {
                Text("Hoş geldin, \(user.displayName ?? "Bilinmeyen Kullanıcı")!")
                    .font(.title)

                List(bookViewModel.books.filter { $0.userId == user.uid }) { book in
                    NavigationLink(destination: BookDetailView(isPresented: $isDetailViewPresented, bookViewModel: BookViewModel(selectedBook: book))){
                        BookRowView(book: book, removeBookAction: {})
                    }
                }
                .listStyle(PlainListStyle())

                Button("Çıkış Yap") {
                    logout() // Çıkış yap butonuna tıklanınca logout fonksiyonunu çağır
                }
                .padding()
            } else {
                Text("Giriş yapmış bir kullanıcı bulunmamaktadır.")
            }

            Spacer()
        }
        .onAppear {
            if let currentUser = Auth.auth().currentUser {
                self.user = currentUser
            }
        }
        .padding()
        .navigationBarTitle("Profil")
        .fullScreenCover(isPresented: $isLoggedOut) {
            SplashScreen() // SplashScreen'a yönlendir
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            user = nil
            isLoggedOut = true // Çıkış yaptığımızda SplashScreen'a yönlendir
        } catch let error {
            print("Çıkış yapılırken hata oluştu: \(error.localizedDescription)")
        }
    }
}
