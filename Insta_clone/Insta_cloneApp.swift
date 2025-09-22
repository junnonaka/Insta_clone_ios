//
//  Insta_cloneApp.swift
//  Insta_clone
//
//  Created by 野中淳 on 2025/09/21.
//

import SwiftUI
import Firebase
@main
struct Insta_cloneApp: App {
    
    var authService:AuthService
    
    init(){
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        self.authService = FirebaseAuthService()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthManager(authService: authService))
        }
    }
}
