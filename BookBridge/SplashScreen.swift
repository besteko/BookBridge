//
//  ContentView.swift
//  bitirmeprojesi
//
//  Created by Beste Kocaoglu on 6.11.2023.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        
        
        NavigationView{
            
            
            ZStack {
                
                
                Color(red: 1.2, green: 1.1, blue: 0.9)
                
                VStack {
                    // Üst boşluğu ayarlar
                    Spacer()
                   /* ZStack {
                      Circle()
                            .stroke(.red, lineWidth: 4)
                      
                      Text("beste kocaoğlu")
                    }
                    .frame(width: 100, height: 100) */
                    
                    Text("WELCOME TO")
                        .font(.largeTitle)
                        .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.1))
                        .multilineTextAlignment(.center)
                        .bold()
                        .padding(40)
                        .shadow(color: .orange ,radius: 20)
                        
                    
                    
                    
                    
                    
                    Image("bookstack") // Orta kısma resmi ekler
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .shadow(color: .orange , radius: 20)
                    
                    // Resim ile giriş butonu arasında boşluk bırakır
                    
                    Text("BOOK BRIDGE")
                        .font(.largeTitle)
                        .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.1))
                        .multilineTextAlignment(.center)
                        .bold()
                        .padding(40)
                        .shadow(color: .orange ,radius: 30)
                        
                    
                    NavigationLink(destination: LoginView()) {
                                        Text("Giriş yap")
                                        .frame(width: 130,height: 60)
                                        .background(Color(red: 0.5, green: 0.4, blue: 0.1))
                                        .foregroundColor(Color.yellow)
                                        .cornerRadius(30)
                                        .padding(.vertical,50)
                                        .shadow(color: .orange, radius: 5)
                                        .navigationBarBackButtonHidden(true )
                    }
                                    
                                    NavigationLink(destination: SignUpView()) {
                                        Text("Hesabınız yok mu? Kaydol")
                                            .padding(.vertical, 40)
                                            .foregroundColor(.brown)
                                            .underline()
                                            .navigationBarBackButtonHidden(true)
                                            
                                    }
                    
                }
                
                
                
            
                
                
            }.edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
