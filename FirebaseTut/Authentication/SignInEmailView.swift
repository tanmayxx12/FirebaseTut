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
    
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return 
        }
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password )
                print("Success")
                print(returnedUserData)
            } catch {
                print("There was an error: \(error.localizedDescription)")
            }
        }
    }
    
}

struct SignInEmailView: View {
    @StateObject private var viewModel = SignInWithEmailViewModel()
    
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
                    viewModel.signIn()
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
    SignInEmailView()
}
