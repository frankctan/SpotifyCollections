//
//  ImageLoader.swift
//  SpotifyCollections
//
//  Created by Frank Tan on 10/10/17.
//  Copyright © 2017 franktan. All rights reserved.
//

import Foundation
import UIKit

typealias SpotifyID = String

protocol ImageLoaderDelegate: class {
    func imageLoaderDidLoadImage(_ imageLoader: ImageLoader, for album: Album)
}

class ImageLoader {
    // TODO: declare and initialize cache.
    private let hpQ = OperationQueue()
    private let lpQ = OperationQueue()
    private let communicator: AlbumCommunicator

    weak var delegate: ImageLoaderDelegate?

    enum Priority {
        case high, low
    }

    private var opBlocks: [SpotifyID: Operation] = [:]
    private var priorities: [SpotifyID: Priority] = [:]
    private var imageCache: [SpotifyID: UIImage] = [:]

    init(communicator: AlbumCommunicator) {
        let hpThread = DispatchQueue.global(qos: .userInitiated)
        let lpThread = DispatchQueue.global(qos: .default)
        self.hpQ.underlyingQueue = hpThread
        self.lpQ.underlyingQueue = lpThread

        // high priority queue should have more connections vs low priority queue.
        self.hpQ.maxConcurrentOperationCount = 5
        self.lpQ.maxConcurrentOperationCount = 2

        self.communicator = communicator
    }

    func getImage(for album: Album, with priority: Priority) {
        if let image = self.imageCache[album.spotifyID] {
            print("image cache - \(album.spotifyID)")
            album.image = image
            return
        }
        // Return if image has already been assigned the same priority.
        guard self.priorities[album.spotifyID] != priority else {
            return
        }

        print("image network request - \(album.spotifyID)")
        // If priority has changed, cancel the operation block and remove the spotifyID.
        if let p = self.priorities[album.spotifyID], p != priority {
            self.opBlocks[album.spotifyID]?.cancel()
            self.remove(id: album.spotifyID)
        }

        // Make the image retrieval operation and add to the correct operation queue.
        let op = self.makeImageOperation(for: album)
        self.track(id: album.spotifyID, operation: op, priority: priority)
        self.add(op: op, with: priority)
    }

    /// Adds an Operation to an OperationQueue based on priority.
    private func add(op: Operation, with priority: Priority) {
        switch priority {
        case .high:
            self.hpQ.addOperation(op)
        case .low:
            self.lpQ.addOperation(op)
        }
    }

    /// Returns a `BlockOperation` which contains an asynchronous image operation.
    private func makeImageOperation(for album: Album) -> Operation {
        let op = BlockOperation {
            self.communicator.getImage(for: album, { (image) in
                album.image = image

                // Store in imageCache and notify delegate that we've loaded a new image.
                DispatchQueue.main.async {
                    self.imageCache[album.spotifyID] = image
                    self.delegate?.imageLoaderDidLoadImage(self, for: album)
                }
            })

            // Nil out the reference to this operation when it begins execution.
            self.remove(id: album.spotifyID)
        }

        return op
    }

    /// Track outstanding operations based on SpotifyID.
    private func track(id: SpotifyID, operation: Operation, priority: Priority) {
        DispatchQueue.main.async {
            self.opBlocks[id] = operation
            self.priorities[id] = priority
        }
    }

    /// Remove outstanding operations from tracking.
    private func remove(id: SpotifyID) {
        DispatchQueue.main.async {
            self.opBlocks[id] = nil
            self.priorities[id] = nil
        }
    }
}
