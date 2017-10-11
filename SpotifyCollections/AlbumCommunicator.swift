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

    /**
     - parameter completion: Called when network request is completed with albums retrieved and API
     offset.
     */
    func getNewReleases(_ completion: @escaping ([Album], Int) -> Void) {
        guard let auth = self.token?.authHeader else {
            return
        }
        let request = SpotifyAPI.newReleases(auth, self.pointer.limit, self.pointer.offset).request

        let task =
            URLSession
                .shared
                .dataTask(with: request) { (dataOrNil, _, errorOrNil) in
                    if let error = errorOrNil {
                        print(error)
                        return
                    }

                    guard let data = dataOrNil,
                        let albums = Album.initMultipleAlbums(data: data) else {
                        return
                    }

                    completion(albums, self.pointer.offset)

                    self.pointer.offset += self.pointer.limit
        }

        task.resume()
    }

    func getImage(for album: Album, _ completion: @escaping (UIImage) -> Void) {
        self.getImage(from: album.imageURL) { (data) in
            guard let image = UIImage(data: data) else {
                print("unable to convert data into UIImagae")
                return
            }
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
