//
//  SettingsView.swift
//  FirebaseTut
//
//  Created by Tanmay . on 28/01/25.
//

import SwiftUI

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


struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack {
            List {
                Button("Log Out") {
                    Task {
                        do {
                            try viewModel.signOut()
                            showSignInView = true
                        } catch {
                            print("There was an error: \(error.localizedDescription)")
                        }
                    }
                }
                
                Button("Delete Account", role: .destructive) {
                    Task {
                        do {
                            try await viewModel.deleteAccount()
                        } catch {
                            print("\(error.localizedDescription)")
                        }
                    }
                }
                
                
                if viewModel.authProviders.contains(.email) {
                    emailSection
                }
                
                if viewModel.authUser?.isAnonymous == true {
                    anonymousSection
                }
                
                
            }
            .onAppear{
                viewModel.loadAuthUser()
                viewModel.loadAuthProviders()
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false))
}

// MARK: Authentication by using email and password: 
extension SettingsView {
    private var emailSection: some View {
        Section("Email Functions") {
            Button("Reset Password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        showSignInView = true
                    } catch {
                        print("There was an error: \(error.localizedDescription)")
                    }
                }
            }
            
            Button("Update Password") {
                Task {
                    do {
                        try await viewModel.updatePassword()
                    } catch {
                        print("There was an error updating password: \(error.localizedDescription)")
                    }
                }
            }
            
            Button("Update email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                    } catch {
                        print("There was an error updating email: \(error.localizedDescription)")
                    }
                }
            }
        }
        
    }
    
    private var anonymousSection: some View {
        Section("Create Account") {
            
            Button("Link Email Account") {
                Task {
                    do {
                        try await viewModel.linkEmailAccount()
                        print("Email Linked")
                    } catch {
                        print("There was an error updating password: \(error.localizedDescription)")
                    }
                }
            }
             
            Button("Link Google Account") {
                Task {
                    do {
                        try await viewModel.linkGoogleAccount()
                        print("Google Linked")
                    } catch {
                        print("There was an error: \(error.localizedDescription)")
                    }
                }
            }
        
            
            
        }

    }
    
}
