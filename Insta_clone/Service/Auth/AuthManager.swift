//
//  AuthManager.swift
//  Insta_clone
//
//  Created by 野中淳 on 2025/09/22.
//

import Foundation
import Combine

@MainActor
final class AuthManager : ObservableObject{
    @Published var currentUser:AppUser? = nil
    let authService:AuthService
    
    init(authService:AuthService) {
        self.authService = authService
        self.currentUser = authService.currentUser
    }
    
    func setLoggedInUser(_ user:AppUser){
        currentUser = user
    }
    
    func requireLogin(presentIfNeeded:Bool = true) -> Bool{
        return currentUser != nil
    }
    
    func signOut() {
        do {
            try authService.signOut()
            currentUser = nil
        } catch {
            print("signOut error:", error)
        }
    }
    
    // factory helpers (optional)
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(authService: authService)
    }
    func makeSignupViewModel() -> SignupViewModel {
        SignupViewModel(authService: authService)
    }
    
}
