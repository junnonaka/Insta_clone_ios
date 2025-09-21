//
//  AuthService.swift
//  Insta_clone
//
//  Created by 野中淳 on 2025/09/21.
//

import Foundation
import FirebaseAuth

protocol AuthService {
    func signIn(email:String,password:String) async throws -> AppUser
    func signUp(email:String,password:String,displayName:String?) async throws -> AppUser
    func signOut() throws
    var currentUser:AppUser? { get }
    
}
