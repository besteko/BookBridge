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
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                SecureField("Şifre", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    
                Text("beste")
                    

                if let error = loginError {
                    Text("Hata: \(error.localizedDescription)")
                        .foregroundColor(.red)
                }

                NavigationLink(destination: HomeView(bookViewModel: BookViewModel()), isActive: $isLoggedIn) {
                    EmptyView()
                }

                Button(action: {
                    login()
                }) {
                    Text("Giriş Yap")
                }
                .padding()

                Spacer()
            }
            .padding()
            .onAppear {
                // Eğer kullanıcı kayıt olma ekranından yönlendirilmişse, otomatik olarak giriş yap
                if isLoggedIn {
                    // Burada ana sayfaya geçiş yapabilirsiniz
                }
            }
           // .navigationBarTitle("Giriş Yap")
            .navigationBarBackButtonHidden(true)
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

