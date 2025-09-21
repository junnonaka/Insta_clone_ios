//
//  AppUser.swift
//  Insta_clone
//
//  Created by 野中淳 on 2025/09/21.
//

import Foundation

struct AppUser: Identifiable, Codable {
    let id: String
    let email: String
    let displayName: String?
    var isEmailVerified: Bool
}
