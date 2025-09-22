//
//  FirebaseAuthService.swift
//  Insta_clone
//
//  Created by 野中淳 on 2025/09/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum AuthError: Error {
    case missingFirebaseUser
    case unknown
}

final class FirebaseAuthService : AuthService{
    private let db = Firestore.firestore()
    
    var currentUser:AppUser?{
        guard let user = Auth.auth().currentUser else {return nil}
        return AppUser(id: user.uid, email: user.email!, displayName: user.displayName, isEmailVerified: user.isEmailVerified)
    }
    
    func signIn(email: String, password: String) async throws -> AppUser {
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error { continuation.resume(throwing: error);return}
                if let user = result?.user {
                    continuation.resume(returning:AppUser(id: user.uid, email: user.email!, displayName: user.displayName, isEmailVerified: user.isEmailVerified))
                }else{
                    continuation.resume(throwing: AuthError.unknown)
                }
            }
        }
    }
    
    func signUp(email: String, password: String,displayName: String?) async throws -> AppUser {
        //createUser
        let user = try await createUser(email: email, password: password)
        
        //displayname Update
        if let name = displayName{
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
                changeRequest.commitChanges { (error) in
                    if let error = error { cont.resume(throwing: error);return }
                    cont.resume(returning: ())
                }
            }
        }
        
        //send verification email
        try await sendEmailVerification(user: user)
        
        // 4) create app-level user doc in Firestore
        let appUser = AppUser(id: user.uid, email: user.email!, displayName: user.displayName, isEmailVerified: user.isEmailVerified)
        try await saveUserProfileToFirestore(appUser)
        
        return appUser
        
    }
    
    
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    //helper
    private func createUser(email:String,password:String) async throws -> FirebaseAuth.User{
        try await withCheckedThrowingContinuation { continuation in
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let error = error { continuation.resume(throwing: error);return}
                if let user = user?.user {
                    continuation.resume(returning: user)
                }else{
                    continuation.resume(throwing: AuthError.unknown)
                }
            }
        }
    }
    
    private func sendEmailVerification(user: FirebaseAuth.User) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            user.sendEmailVerification { err in
                if let e = err { cont.resume(throwing: e); return }
                cont.resume(returning: ())
            }
        }
    }
    
    private func saveUserProfileToFirestore(_ appUser: AppUser) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            let data: [String:Any] = [
                "email": appUser.email ?? NSNull(),
                "displayName": appUser.displayName ?? NSNull(),
                "createdAt": FieldValue.serverTimestamp()
            ]
            db.collection("users").document(appUser.id).setData(data) { err in
                if let error = err { cont.resume(throwing: error); return }
                cont.resume(returning: ())
            }
        }
        
    }
    
    
}
