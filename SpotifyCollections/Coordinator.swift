//
//  Coordinator.swift
//  SpotifyCollections
//
//  Created by Frank Tan on 10/9/17.
//  Copyright © 2017 franktan. All rights reserved.
//

import Foundation
import UIKit


class Coordinator {
    let communicator = AlbumCommunicator()
    let rootViewController = CollectionViewController()
    let imageLoader: ImageLoader

    init() {
        self.imageLoader = ImageLoader(communicator: self.communicator)
        self.rootViewController.delegate = self
        self.imageLoader.delegate = self
        self.communicator.getToken {
            print("successfully retrieved and assigned token")
            self.communicator.getNewReleases { (albums) in
                for i in 0..<albums.count {
                    self.rootViewController.dataSource[i] = albums[i]
                    self.communicator.getImage(from: albums[i].imageURL, { (data) in
                        albums[i].image = UIImage(data: data)
                    })
                }
            }
        }
    }



// MARK: - ImageLoaderDelegate

extension Coordinator: ImageLoaderDelegate {
    func imageLoaderDidLoadImage(_ imageLoader: ImageLoader, for album: Album) {
        self.rootViewController.refresh(album: album)
    }
}
