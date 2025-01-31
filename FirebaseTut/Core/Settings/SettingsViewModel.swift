//
//  SettingsViewModel.swift
//  FirebaseTut
//
//  Created by Tanmay . on 31/01/25.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var authProviders: [AuthProviderOptions] = []
    @Published var authUser: AuthDataResultModel? = nil
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func loadAuthUser() {
        self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.badServerResponse)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "tanmayxx123@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "Hello123"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func linkEmailAccount() async throws {
        let email = "hello123@gmail.com"
        let password = "Hello123!"
        let authDataResult = try await AuthenticationManager.shared.linkEmail(email: email, password: password)
        self.authUser = authDataResult
    }
    
    func linkGoogleAccount() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
        self.authUser = authDataResult
    }
    
}
