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
    
    // Getting the Authenticated user:
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user )
    }

    // Function to sign out the user:
    func signOut() throws {
        try Auth.auth().signOut()
    }
}

// MARK: Sign In EMAIL
extension AuthenticationManager {
    // Creating a new user:
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let result = AuthDataResultModel(user: authDataResult.user)
        return result
    }
    
    // Function to sign in the user
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    // Function to reset password
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    // Function to update the password
    func updatePassword(password: String) async throws {
        guard let user =  Auth.auth().currentUser else {
            throw URLError(.badServerResponse)  // Throw a valid error in production ready apps
        }
        try await user.updatePassword(to: password)
    }
    
    // Function to update the email
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse) // Throw a valid error in productin ready apps
        }
        try await user.sendEmailVerification(beforeUpdatingEmail: email)
    }
}


// MARK: Sign In SSO
extension AuthenticationManager {
    
    func signInWithGoogle(credential: AuthCredential) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
}
