//
//  AuthenticationView.swift
//  FirebaseTut
//
//  Created by Tanmay . on 28/01/25.
//

import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import SwiftUI


// Creating a view model:
@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
     
    func signInAnonymous() async throws {
        try await AuthenticationManager.shared.signInAnonymous()
    }
    
    
}

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    Task {
                        do {
                            try await viewModel.signInAnonymous()
                            showSignInView = false
                        } catch {
                            print("There was an error: \(error.localizedDescription)")
                        }
                    }
                } label: {
                    Text("Sign In Anonymously")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.black.opacity(0.5))
                        .cornerRadius(10)
                }
                
                NavigationLink {
                    SignInEmailView(showSignInView: $showSignInView)
                } label: {
                    Text("Sign In With Email")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .cornerRadius(10)
                }

                
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                    Task {
                        do {
                            try await viewModel.signInGoogle()
                            showSignInView = false
                        } catch {
                            print("There was an error: \(error.localizedDescription)")
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Sign In")
        }
        
    }
}

#Preview {
    AuthenticationView(showSignInView: .constant(false))
}
