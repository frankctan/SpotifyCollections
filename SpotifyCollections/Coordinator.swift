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
    var albums: [Album] = []
    let rootViewController = CollectionViewController()

    init() {
        self.communicator.getToken {
            print("successfully retrieved and assigned token")
            self.communicator.getNewReleases(limit: 10, offset: 0, { (albums) in
                self.albums = albums
                self.communicator.getImage(from: albums[0].imageURL, { (data) in
                    let image = UIImage(data: data)
                    print("retrieved image")
                })
            })
        }
    }


}
