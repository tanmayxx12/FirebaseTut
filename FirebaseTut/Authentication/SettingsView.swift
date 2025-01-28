//
//  SettingsView.swift
//  FirebaseTut
//
//  Created by Tanmay . on 28/01/25.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
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
                            print("There was an error")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false))
}
