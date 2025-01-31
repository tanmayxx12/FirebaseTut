//
//  SignInEmailViewModel.swift
//  FirebaseTut
//
//  Created by Tanmay . on 31/01/25.
//

import Foundation

// Creating a view model:
@MainActor
final class SignInWithEmailViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }

        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password )
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
    }
    
}
