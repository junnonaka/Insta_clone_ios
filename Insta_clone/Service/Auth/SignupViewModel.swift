//
//  SignupViewModel.swift
//  Insta_clone
//
//  Created by 野中淳 on 2025/09/22.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class SignupViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var displayName = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let authService: AuthService
    
    init(authService: AuthService = FirebaseAuthService()) {
        self.authService = authService
    }
    
    func signUp() async throws -> AppUser {
        guard !email.isEmpty, !password.isEmpty, !displayName.isEmpty else {
            errorMessage = "すべての項目を入力してください"
            throw ValidationError.missingFields
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authService.signUp(
                email: email,
                password: password,
                displayName: displayName.isEmpty ? nil : displayName
            )
            isLoading = false
            return user
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            throw error
        }
    }
}
