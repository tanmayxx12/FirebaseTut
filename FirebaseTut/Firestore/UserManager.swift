//
//  UserManager.swift
//  FirebaseTut
//
//  Created by Tanmay . on 31/01/25.
//

import FirebaseFirestore
import Foundation


final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        var userData: [String : Any] = [
            "user_id" : auth.uid,
            "is_anonymous" : auth.isAnonymous,
            "date_created" : Timestamp(),
            "email" : auth.email ?? "",
        ]
        
        if let email = auth.email{
            userData["email"] = email
        }
        if let photoURL = auth.photoUrl {
            userData["photo_url"] = photoURL
        }
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
    // Left at 29:40 -> How to Set Up User Profiles in Firebase Firestore for iOS | Firebase Bootcamp #9
//    func getUser(userID: String) async throws -> String {
//        let snapshot = try await Firestore.firestore().collection("users").document(userID).getDocument()
//        guard let data = snapshot.data() else {
//            throw URLError(.badServerResponse)
//        }
//    }
    
    
}
