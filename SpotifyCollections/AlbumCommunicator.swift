//
//  AlbumCommunicator.swift
//  SpotifyCollections
//
//  Created by Frank Tan on 10/7/17.
//  Copyright © 2017 franktan. All rights reserved.
//

import Foundation
import UIKit

struct SpotifyPointer {
    var limit: Int = 40
    var offset: Int = 0
}

class AlbumCommunicator {
    private let queue: OperationQueue
    private var token: TokenInfo?
    private var pointer = SpotifyPointer()

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

    func getNewReleases(_ completion: @escaping ([Album]) -> Void) {
        guard let auth = self.token?.authHeader else {
            return
        }

        let task =
            URLSession
                .shared
                .dataTask(with: SpotifyAPI.newReleases(auth, limit, offset).request) { (dataOrNil, _, errorOrNil) in
                    if let error = errorOrNil {
                        print(error)
                        return
                    }

                    self.pointer.offset += self.pointer.limit

                    guard let data = dataOrNil,
                        let albums = Album.initMultipleAlbums(data: data) else {
                        return
                    }

                    completion(albums)
        }

        task.resume()
    }

    func getImage(for album: Album, _ completion: @escaping (UIImage) -> Void) {
        self.getImage(from: album.imageURL) { (data) in
            let image = UIImage(data: data)
            completion(image)
        }
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
