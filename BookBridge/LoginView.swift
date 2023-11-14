//
//  SignInView.swift
//  bitirmeprojesi
//
//  Created by Beste Kocaoglu on 9.11.2023.
//

import SwiftUI

struct LoginView: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State var backgroundColor : Color = Color(red: 1.2, green: 1.1, blue: 0.9)
    
    var body: some View {
        NavigationView{
            ZStack{
                
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    Image("bookicon")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .position(.init(x: 188, y: 70))
                        .padding(.top, 50)
                    
                    Text("Book Bridge")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.brown)
                        .padding(.bottom,80)
                        .shadow(color: .orange, radius: 10)
                    
                    CardView {
                        
                        TextField("Kullanıcı Adı", text: $username)
                                                .padding()
                                                .border(Color.gray, width: 1)
                                                .cornerRadius(10)
                                                

                                            SecureField("Şifre", text: $password)
                                                .padding()
                                                .border(Color.gray, width: 1)
                                                .cornerRadius(10)
                                                
                    }.padding(.top, 50.0)
                    Button(action: {
                                        //signIn()
                                    }) {
                                        Text("Giriş Yap")
                                            .padding()
                                            .frame(width: 300, height: 60 , alignment: .center)
                                            .background(Color.orange)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                            
                                            
                                    }
                                    .alert(isPresented: $showAlert) {
                                        Alert(title: Text("Hata"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
                                    }
                    NavigationLink(destination: SignUpView()) {
                        Text("Hesabınız yok mu? Kaydol")
                            .padding(.vertical, 40)
                            .foregroundColor(.brown)
                            .underline()
                            .navigationBarBackButtonHidden(true)
                            
                    }
                                    Spacer()
                    }
                                        
                }
            }
        }
    }
    
    
    
    struct SignInView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView()
        }
    }


struct CardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            content
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.8, minHeight: UIScreen.main.bounds.height * 0.2)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 2)
        .padding(.horizontal)
        .position(x: 200)
    }
}

