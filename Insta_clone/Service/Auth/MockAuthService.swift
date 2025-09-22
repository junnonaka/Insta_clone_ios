//
//  MockAuthService.swift
//  Insta_clone
//
//  Created by 野中淳 on 2025/09/22.
//

import Foundation
final class MockAuthService: AuthService {
    
    private var current: AppUser?

    var currentUser: AppUser? { current }

    func signIn(email: String, password: String) async throws -> AppUser {
        // 簡易シミュレーション（遅延を入れるとより実際に近い）
        try await Task.sleep(nanoseconds: 100_000_000)
        let u = AppUser(id: "mock-uid", email: email, displayName: "Mock User", isEmailVerified: true)
        current = u
        return u
    }

    func signUp(email: String, password: String, displayName: String?) async throws -> AppUser {
        try await Task.sleep(nanoseconds: 100_000_000)
        let u = AppUser(id: "mock-uid-signup", email: email, displayName: displayName ?? "New Mock", isEmailVerified: false)
        current = u
        return u
    }

    func signOut() throws {
        current = nil
    }
}
