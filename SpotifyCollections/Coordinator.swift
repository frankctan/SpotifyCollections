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

    init() {
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



}
