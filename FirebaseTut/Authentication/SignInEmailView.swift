//
//  SignInEmailView.swift
//  FirebaseTut
//
//  Created by Tanmay . on 28/01/25.
//

import SwiftUI


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

        let _ = try await AuthenticationManager.shared.createUser(email: email, password: password )
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        
        let _ = try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
    
}

struct SignInEmailView: View {
    @StateObject private var viewModel = SignInWithEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email...", text: $viewModel.email)
                    .padding()
                    .font(.headline)
                    .background(.black.opacity(0.2))
                    .cornerRadius(10)
                    .padding(6)
                    .textInputAutocapitalization(.never)
                
                SecureField("Password...", text: $viewModel.password)
                    .padding()
                    .font(.headline)
                    .background(.black.opacity(0.2))
                    .cornerRadius(10)
                    .padding(6)
                    .textInputAutocapitalization(.never)
                
                Button {
                    Task {
                        do {
                            try await viewModel.signUp()
                            showSignInView = false
                        } catch {
                            print("There was an error signing up: \(error.localizedDescription)")
                        }
                        
                        do {
                            try await viewModel.signIn()
                            showSignInView = false
                            return
                        } catch {
                            print("There was an error signing in: \(error.localizedDescription)")
                        }
                        
                    }
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .cornerRadius(10)
                        .padding(6)
                }
                
                Spacer()
            }
            .navigationTitle("Sign In With Email")
        }
    }
}

#Preview {
    SignInEmailView(showSignInView: .constant(false))
}
