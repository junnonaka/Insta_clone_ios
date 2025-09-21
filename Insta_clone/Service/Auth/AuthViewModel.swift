//
//  AuthViewModel.swift
//  Insta_clone
//
//  Created by 野中淳 on 2025/09/21.
//

import Foundation
import Combine

final class AutAuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var displayName = "" // signUp 用（任意）
    
    @Published var currentUser: AppUser?
    
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let authService: AuthService
    
    //依存性の注入
    init(authService:AuthService = FirebaseAuthService()){
        self.authService = authService
        self.currentUser = authService.currentUser
    }
    
    func signin(){
        //バリデーション
        errorMessage = nil
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,!password.isEmpty else {
            errorMessage = "メールアドレスとパスワードを入力してください。"
            return
        }
        
        isLoading = true
        Task{
            do{
                let user = try await authService.signIn(email: email, password: password)
                self.currentUser = user
            }catch{
                self.errorMessage = "サインインに失敗しました。"
            }
            self.isLoading = false
        }
    }
    
    func signup(){
        errorMessage = nil
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,!password.isEmpty else {
            errorMessage = "メールアドレスとパスワードを入力してください。"
            return
        }
        isLoading = true
        Task{
            do{
                let user = try await authService.signUp(email: email, password: password, displayName: displayName.isEmpty ? nil : displayName)
                self.currentUser = user
                if !user.isEmailVerified{
                    self.errorMessage = "確認メールを送信しました。受信トレイを確認してください。"
                }
            }catch{
                
            }
            isLoading = false
        }
    }
    
    func signOut(){
        do{
            try authService.signOut()
            self.currentUser = nil
        }catch{
            self.errorMessage = "サインアウトに失敗しました。"
        }
    }
    
    private 
    
    
}
