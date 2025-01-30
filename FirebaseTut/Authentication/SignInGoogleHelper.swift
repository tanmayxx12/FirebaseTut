//
//  SignInGoogleHelper.swift
//  FirebaseTut
//
//  Created by Tanmay . on 30/01/25.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
}

final class SignInGoogleHelper {
    
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        let gidSignedInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        guard let idToken: String = gidSignedInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken: String = gidSignedInResult.user.accessToken.tokenString
        let name: String = gidSignedInResult.user.profile?.name ?? ""
        let email: String = gidSignedInResult.user.profile?.email ?? ""
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
        
        return tokens
    }
}
