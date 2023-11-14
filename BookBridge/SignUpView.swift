//
//  loginView.swift
//  bitirmeprojesi
//
//  Created by Beste Kocaoglu on 7.11.2023.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isRegistered = false
    
    var body: some View {
        
        ZStack{
            
            Color(red: 1.2, green: 1.1, blue: 0.9)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("bookgirlx2x") // Üstteki resim
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: UIScreen.main.bounds.height * 0.2 , alignment: .center)
                    .padding(.top, 50.0)
                    .shadow(color: .orange, radius: 2)
                    
                
                // Kart (Bilgi Girişi)
                CardView(email: $email, username: $username, password: $password, confirmPassword: $confirmPassword)
                
                Spacer()
                
                Button(action: {
                    // "Kaydol" butonuna basıldığında kayıt işlemi
                    // Burada kayıt işlemini gerçekleştirebilirsiniz.
                    
                    // Örnek: Eğer kayıt başarılıysa, giriş sayfasına yönlendirme işlemi
                    isRegistered = true
                }) {
                    Text("Kaydol")
                        .foregroundColor(.yellow)
                        .padding()
                        .background(Color(red: 0.7, green: 0.35, blue: 0.10))
                        .cornerRadius(10)
                        .padding()

                }
                
                Text("Hesabın var mı? Giriş yap")
                    .underline()
                    .padding(.bottom, 50)
                    .onTapGesture {
                        // "Giriş yap" metnine tıklandığında giriş sayfasına geçiş işlemi
                        isRegistered = true
                    }
            }
            .padding()
            .edgesIgnoringSafeArea(.all)
            .fullScreenCover(isPresented: $isRegistered) {
                LoginView()
            }
        }
    }
    
    struct CardView: View {
        @Binding var email: String
        @Binding var username: String
        @Binding var password: String
        @Binding var confirmPassword: String
        
        var body: some View {
            RoundedRectangle(cornerRadius: 90)
                .foregroundColor(.white)
                .frame(maxWidth: UIScreen.main.bounds.width * 1.9, minHeight: UIScreen.main.bounds.height * 0.5)
                .overlay(
                    VStack(spacing: 26) {
                        Text("Lütfen Bilgilerinizi Giriniz")
                            .foregroundColor(.brown)
                        TextField("E-Posta", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Kullanıcı Adı", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        SecureField("Şifre", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        SecureField("Şifre Tekrar", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        }
                        .padding(9)
                )
                .padding(5)
                .shadow(color: .orange, radius: 0.4)
                
        }
    }
    
}


struct loginView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
