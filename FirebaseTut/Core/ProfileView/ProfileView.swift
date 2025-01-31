//
//  ProfileView.swift
//  FirebaseTut
//
//  Created by Tanmay . on 31/01/25.
//

import SwiftUI

// Creating a viewModel:
@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: AuthDataResultModel? = nil
    
    func loadCurrentUser() throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = authDataResult
    }
}


struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack {
            List {
                if let user = viewModel.user {
                    Text("UserID: \(user.uid)")
                }
                
            }
            .navigationTitle("Profile")
            .onAppear{
                try? viewModel.loadCurrentUser()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView(showSignInView: $showSignInView)
                    } label: {
                        Image(systemName: "gear")
                            .font(.headline)
                    }

                }
            }
        }
    }
}

#Preview {
    ProfileView(showSignInView: .constant(false))
}
