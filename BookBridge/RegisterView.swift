//
//  RegisterView.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 20.11.2023.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var registrationError: Error?
    @State private var isRegistered: Bool = false

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
                    .textContentType(.newPassword)

                SecureField("Şifreyi Onayla", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    

                if let error = registrationError {
                    Text("Hata: \(error.localizedDescription)")
                        .foregroundColor(.red)
                }

                NavigationLink(destination: LoginView(), isActive: $isRegistered) {
                    EmptyView()
                }

                Button(action: {
                    register()
                }) {
                    Text("Kayıt Ol")
                }
                .padding()

                Spacer()
            }
            .padding()
           // .navigationBarTitle("Kayıt Ol")
            .navigationBarBackButtonHidden(true)
        }
    }

    func register() {
        if password == confirmPassword {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Kullanıcı kaydı başarısız: \(error.localizedDescription)")
                    self.registrationError = error
                } else {
                    print("Kullanıcı kaydı başarılı")
                    self.isRegistered = true
                }
            }
        } else {
            self.registrationError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Şifreler uyuşmuyor."])
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
