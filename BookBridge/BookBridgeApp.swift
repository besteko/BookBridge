//
//  BookBridgeApp.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 12.11.2023.
//

import SwiftUI
import Firebase

@main
struct BookBridgeApp: App {
    init() {
            FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
    }
}
