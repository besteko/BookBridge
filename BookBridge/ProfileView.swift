//
//  ProfileView.swift
//  bitirmedeneme
//
//  Created by Beste Kocaoglu on 21.11.2023.
//
import SwiftUI
import Firebase
import FirebaseAuth

struct ProfileView: View {
    @State private var isDetailViewPresented = false
    @ObservedObject var bookViewModel: BookViewModel
    @State private var user: User?
    @State private var isLoggedOut = false
    @State private var isImagePickerPresented = false
    @State private var selectedAvatar: String?

    // Örnek avatarlar
    let avatars = ["womanone", "woman", "womantwo", "rabbit", "man", "chicken","human","astronaut","gamer","panda"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let user = user {
                VStack(alignment: .center, spacing: 16) {
                    VStack {
                        Button(action: {
                            isImagePickerPresented.toggle()
                        }) {
                            if let selectedAvatar = selectedAvatar {
                                Image(selectedAvatar)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            } else {
                                Text("Select Avatar")
                                    .foregroundColor(.blue)
                            }
                        }
                        .sheet(isPresented: $isImagePickerPresented) {
                            AvatarGalleryView(avatars: avatars) { selectedAvatar in
                                // Avatar galerisinden seçilen avatarı kullanıcının profiline kaydet
                                self.selectedAvatar = selectedAvatar
                                isImagePickerPresented.toggle() // Avatar seçildikten sonra AvatarView'ı kapat
                                
                                // Directly unwrap user.uid since it's not optional
                                UserDefaultsManager.shared.saveSelectedAvatar(forUserID: user.uid ?? "", avatar: selectedAvatar)
                            }
                        }
                    }

                    VStack(alignment: .center, spacing: 8) {
                        Text(
                            " \(user.displayName ?? "Bilinmeyen Kullanıcı")")
                            .font(.title)
                            .foregroundColor(.primary)

                        Spacer()

                        List(bookViewModel.books.filter { $0.userId == user.uid }) { book in
                            NavigationLink(
                                destination: BookDetailView(
                                    isPresented: $isDetailViewPresented, bookViewModel: BookViewModel(selectedBook: book)
                                )
                            ) {
                                BookRowView(book: book, removeBookAction: {})
                            }
                        }
                        .listStyle(PlainListStyle())
                        .padding(.top, 8)
                    }
                }
                .padding()
                
                Spacer()
            } else {
                Text("Giriş yapmış bir kullanıcı bulunmamaktadır.")
                    .foregroundColor(.secondary)
                    .padding()
            }

            Spacer()

            Button(action: {
                logout()
            }) {
                Text("Çıkış Yap")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                    
            }
            //.frame(maxHeight: 50 )
        }
        .onAppear {
            if let currentUser = Auth.auth().currentUser {
                  self.user = currentUser
                  // Kullanıcı her giriş yaptığında kaydedilmiş avatarı getir
                  self.selectedAvatar = UserDefaultsManager.shared.getSelectedAvatar(forUserID: currentUser.uid)
              }
        }
        .fullScreenCover(isPresented: $isLoggedOut) {
            SplashScreen()
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            user = nil
            isLoggedOut = true
            // Kullanıcı çıkış yaptığında avatar bilgisini sil
            UserDefaultsManager.shared.removeSelectedAvatar(forUserID: user?.uid ?? "")
        } catch let error {
            print("Çıkış yapılırken hata oluştu: \(error.localizedDescription)")
        }
    }
}



