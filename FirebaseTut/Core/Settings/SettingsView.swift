//
//  SettingsView.swift
//  FirebaseTut
//
//  Created by Tanmay . on 28/01/25.
//

import SwiftUI

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
