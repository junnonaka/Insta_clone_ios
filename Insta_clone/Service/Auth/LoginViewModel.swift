//
//  LoginViewModel.swift
//  Insta_clone
//
//  Created by 野中淳 on 2025/09/22.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let authService: AuthService
    
    init(authService: AuthService = FirebaseAuthService()) {
        self.authService = authService
    }
    
    func signIn() async throws -> AppUser {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "メールアドレスとパスワードを入力してください"
            throw ValidationError.missingCredentials
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authService.signIn(email: email, password: password)
            isLoading = false
            return user
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            throw error
        }
    }
}

enum ValidationError: Error, LocalizedError {
    case missingCredentials
    case missingFields
    
    var errorDescription: String? {
        switch self {
        case .missingCredentials:
            return "メールアドレスとパスワードを入力してください"
        case .missingFields:
            return "すべての項目を入力してください"
        }
    }
}
