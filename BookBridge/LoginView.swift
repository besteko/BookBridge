//
//  LoginView.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 15.11.2023.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginError: Error?
    @State private var isLoggedIn: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 1.2, green: 1.1, blue: 0.9)
                    .ignoresSafeArea()

                VStack {

                    Image("bookicon")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .shadow(color: .orange, radius: 10)

                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    SecureField("Şifre", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    if let error = loginError {
                        Text("Hata: \(error.localizedDescription)")
                            .foregroundColor(.red)
                            .padding()
                    }

                    Button(action: {
                        login()
                    }) {
                        Text("Giriş Yap")
                            .padding()
                            .frame(width: 200, height: 50)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()

                    Spacer()

                    NavigationLink(destination: HomeView(bookViewModel: BookViewModel()).navigationBarBackButtonHidden(true), isActive: $isLoggedIn) {
                        EmptyView()
                    }
                    .navigationBarHidden(true) // Bu satırı ekleyerek navigation bar'ı gizle

                }
                .padding()

            }
            .navigationBarBackButtonHidden(true)
            .navigationViewStyle(StackNavigationViewStyle()) // iPhone'lar için NavigationView stil ayarı
        }
    }

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Giriş başarısız: \(error.localizedDescription)")
                self.loginError = error
            } else {
                print("Giriş başarılı")
                self.isLoggedIn = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
