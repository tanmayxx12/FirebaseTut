//
//  FirebaseTutApp.swift
//  FirebaseTut
//
//  Created by Tanmay . on 28/01/25.
//

import Firebase
import SwiftUI

@main
struct FirebaseTutApp: App {
    
    init() {
        FirebaseApp.configure()
        print("Configured Firebase")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
