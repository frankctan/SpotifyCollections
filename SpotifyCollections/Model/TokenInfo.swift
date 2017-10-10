//
//  TokenInfo.swift
//  SpotifyCollections
//
//  Created by Frank Tan on 10/9/17.
//  Copyright © 2017 franktan. All rights reserved.
//

import Foundation

struct TokenInfo {
    /// When does this information expire?
    let expiry: Int

    /// Type of token. Should be "Bearer" per docs.
    let tokenType: String

    /// Actual token string.
    let accessToken: String

    /// Returns the authorization header.
    var authHeader: String {
        return tokenType + " " + accessToken
    }

    init(_ expiry: Int, _ type: String, _ token: String) {
        self.expiry = expiry
        self.tokenType = type
        self.accessToken = token
    }
}

// MARK: - JSON initializer

extension TokenInfo {
    init?(data: Data) {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return nil
        }
        guard let dictionary = json as? [String: Any] else {
            print("error converting json into dictionary")
            return nil
        }

        guard let expiry = dictionary["expires_in"] as? Int,
            let tokenType = dictionary["token_type"] as? String,
            let accessToken = dictionary["access_token"] as? String else {
                print("TokenInfo is missing fields")
                return nil
        }

        self.init(expiry, tokenType, accessToken)
    }
}
