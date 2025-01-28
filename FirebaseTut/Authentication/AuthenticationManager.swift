//
//  AuthenticationManager.swift
//  FirebaseTut
//
//  Created by Tanmay . on 28/01/25.
//

import FirebaseAuth
import Foundation


struct AuthDataResultModel {
    let uid: String
    let email: String?
     let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    private init() { }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user )
    }
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let result = AuthDataResultModel(user: authDataResult.user)
        return result
    }
    
    
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword(password: String) async throws {
        guard let user =  Auth.auth().currentUser else {
            throw URLError(.badServerResponse)  // Throw a valid error in production ready apps
        }
        try await user.updatePassword(to: password)
    }
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse) // Throw a valid error in productin ready apps
        }
        try await user.sendEmailVerification(beforeUpdatingEmail: email)
    }
    
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    
    
}
