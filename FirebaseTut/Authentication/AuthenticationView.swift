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
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        
        let gidSignedInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
//        gidSignedInResult.
        
        guard let idToken: String = gidSignedInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let accessToken: String = gidSignedInResult.user.accessToken.tokenString
       
        
    }
    
}

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
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
