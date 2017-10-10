//
//  SpotifyAPI.swift
//  SpotifyCollections
//
//  Created by Frank Tan on 10/9/17.
//  Copyright © 2017 franktan. All rights reserved.
//

import Foundation

/**
 Refresh token auth is base64 encoding of Spotify's provided client id and secret key.
 New release auth should be the refresh token.
 */
enum SpotifyAPI {
    case refreshToken(String)
    case newReleases(String, Int, Int)

    private var url: URL? {
        var c = URLComponents()
        c.scheme = "https"

        switch self {
        case .refreshToken(_):
            c.host = "accounts.spotify.com"
            c.path = "/api/token"

        case .newReleases(_, let limit, let offset):
            c.host = "api.spotify.com"
            c.path = "/v1/browse/new-releases"
            let limit = URLQueryItem(name: "limit", value: "\(limit)")
            let offset = URLQueryItem(name: "offset", value: "\(offset)")
            c.queryItems = [limit, offset]
        }

        return c.url
    }

    var request: URLRequest {
        guard let u = self.url else {
            fatalError()
        }
        var r = URLRequest(url: u)

        switch self {
        case .refreshToken(let a):
            r.setValue(a, forHTTPHeaderField: "Authorization")
            r.httpBody = "grant_type=client_credentials".data(using: .utf8)
            r.httpMethod = "POST"

        case .newReleases(let a, _, _):
            r.setValue(a, forHTTPHeaderField: "Authorization")
            r.httpMethod = "GET"
        }

        return r
    }


}
