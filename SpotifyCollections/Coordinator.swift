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
            self.getNewReleasesAndLoadImages(with: .low)
        }
    }

    /**
     - parameter priority - Priority of image loading.
     */
    func getNewReleasesAndLoadImages(with priority: ImageLoader.Priority) {
        self.communicator.getNewReleases { (albums, oldOffset) in
            print("successfully retrieved new releases")
            for i in oldOffset..<(oldOffset + albums.count) {
                let album = albums[i - oldOffset]
                self.rootViewController.dataSource[i] = album
//                self.communicator.getImage(from: albums[i].imageURL, { (data) in
//                    albums[i].image = UIImage(data: data)
//                })
                self.imageLoader.getImage(for: album, with: priority)
            }
        }
    }
}

//MARK: - CollectionViewControllerDelegate

extension Coordinator: CollectionViewControllerDelegate {
    func collectionViewControllerDidUpdateVisibleAlbums(_ viewController: CollectionViewController) {
        DispatchQueue.main.async {
            let visibleAlbums =
                viewController
                    .collectionView?
                    .indexPathsForVisibleItems
                    .flatMap { viewController.dataSource[$0.item] }

            for album in visibleAlbums ?? [Album]() {
                self.imageLoader.getImage(for: album, with: .high)
            }
        }
    }

    func collectionViewControllerNeedsMoreAlbums(_ viewController: CollectionViewController) {
        self.getNewReleasesAndLoadImages(with: .low)
    }
}

// MARK: - ImageLoaderDelegate

extension Coordinator: ImageLoaderDelegate {
    func imageLoaderDidLoadImage(_ imageLoader: ImageLoader, for album: Album) {
        self.rootViewController.refresh(album: album)
    }
}
