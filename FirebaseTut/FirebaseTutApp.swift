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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Configured Firebase")
        return true
    }
}
