//
//  AuthenticationView.swift
//  FirebaseTut
//
//  Created by Tanmay . on 28/01/25.
//

import SwiftUI

struct AuthenticationView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    SignInEmailView()
                } label: {
                    Text("Sign In With Email")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Sign In")
        }
        
    }
}

#Preview {
    AuthenticationView()
}
