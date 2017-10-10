//
//  AlbumCommunicator.swift
//  SpotifyCollections
//
//  Created by Frank Tan on 10/7/17.
//  Copyright © 2017 franktan. All rights reserved.
//

import Foundation

class AlbumCommunicator {
    private let queue: OperationQueue
    private var token: TokenInfo?

    init() {
        let queue = OperationQueue()
        queue.underlyingQueue = DispatchQueue.global(qos: .utility)
        self.queue = queue
    }

    func getToken(_ completion: (() -> Void)?) {
        let task =
            URLSession
                .shared
                .dataTask(with: SpotifyAPI.refreshToken(Secrets.basicAuth).request) {[weak self] (dataOrNil, _, errorOrNil) in
                    if let error = errorOrNil {
                        print(error)
                    }

                    guard let data = dataOrNil else {
                        print("error retrieving data from getToken request")
                        return
                    }

                    self?.token = TokenInfo(data: data)

                    completion?()
        }

        task.resume()
    }

    func getNewReleases(limit: Int, offset: Int, _ completion: @escaping ([Album]) -> Void) {
        guard let auth = self.token?.authHeader else {
            return
        }

        let task =
            URLSession
                .shared
                .dataTask(with: SpotifyAPI.newReleases(auth, limit, offset).request) { (dataOrNil, _, errorOrNil) in
                    if let error = errorOrNil {
                        print(error)
                    }

                    guard let data = dataOrNil,
                        let albums = Album.initMultipleAlbums(data: data) else {
                        return
                    }

                    completion(albums)
        }

        task.resume()
    }

    func getImage(from url: URL, _ completion: @escaping (Data) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (dataOrNil, _, errorOrNil) in
            if let error = errorOrNil {
                print(error)
            }

            guard let data = dataOrNil else {
                return
            }

            completion(data)
        }

        task.resume()
    }
}

//    class func getShit() {
//        guard let url = AlbumCommunicator.createURLPath() else {
//            print("error creating URL")
//            return
//        }
////        var request = URLRequest(url: url)
////        request.setValue(Secrets.oAuth, forHTTPHeaderField: "Authorization")
//    }



//    private class func createURLPath() -> URL? {
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = "api.spotify.com"
//        components.path = "/v1/browse/new-releases"
//        let limitQuery = URLQueryItem(name: "limit", value: "20")
//        let offsetQuery = URLQueryItem(name: "offset", value: "0")
//        components.queryItems = [limitQuery, offsetQuery]
//        return components.url
//    }



