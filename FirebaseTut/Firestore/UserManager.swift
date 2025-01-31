//
//  UserManager.swift
//  FirebaseTut
//
//  Created by Tanmay . on 31/01/25.
//

import FirebaseFirestore
import Foundation


struct DBUser {
    let userID: String
    let isAnonymous: Bool? 
    let email: String?
    let photoURL: String?
    let dateCreated: Date?
}


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
    func getUser(userID: String) async throws -> DBUser  {
        let snapshot = try await Firestore.firestore().collection("users").document(userID).getDocument()
        guard let data = snapshot.data(),
              let userID = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let isAnonymous = data["is_anonymous"] as? Bool
        let email = data["email"] as? String
        let photoURL = data["photo_url"] as? String
        let dateCreated = data["date_created"] as? Date // we pushed it as a timestamp but we are retrieving it as Swift Date
        
        return DBUser(userID: userID, isAnonymous: isAnonymous, email: email, photoURL: photoURL, dateCreated: dateCreated)
    }
    
    
}
