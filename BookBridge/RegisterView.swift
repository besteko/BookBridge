//
//  ContentView.swift
//  bitirmedeneme
//
//  Created by Beste Kocaoglu on 18.11.2023.
//
import SwiftUI
import Firebase

struct RegisterView: View {
    
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var registrationError: Error?
    @State private var isRegistered: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 1.2, green: 1.1, blue: 0.9)
                    .ignoresSafeArea()

                VStack {
                    
                    Image("bookgirlx2x")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .padding(.bottom, 20)
                    
                    TextField("Ad", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .disableAutocorrection(true)
                    
                    TextField("Soyad", text: $surname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .disableAutocorrection(true)

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
                            .padding()
                    }

                    NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true), isActive: $isRegistered) {
                        EmptyView()
                    }

                    Button(action: {
                        register()
                    }) {
                        Text("Kayıt Ol")
                            .frame(width: 200, height: 50)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 15)
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Hesabınız var mı? Giriş yap")
                            .foregroundColor(.brown)
                            .underline()
                            .padding(.top, 20)
                    }
                }
                .padding()

            }
            //.navigationBarTitle("Kayıt Ol", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationViewStyle(StackNavigationViewStyle()) // iPhone'lar için NavigationView stil ayarı
        }
    }

    func register() {
        if password == confirmPassword {
            // Ad ve soyadı kullanarak bir displayName oluştur
            let displayName = "\(name) \(surname)"

            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Kullanıcı kaydı başarısız: \(error.localizedDescription)")
                    self.registrationError = error
                } else {
                    // Kullanıcının displayName'ini güncelle
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = displayName
                    changeRequest?.commitChanges(completion: { _ in
                        print("Kullanıcı adı güncellendi: \(displayName)")
                    })

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


