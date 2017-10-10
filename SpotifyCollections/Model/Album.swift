//
//  Album.swift
//  SpotifyCollections
//
//  Created by Frank Tan on 10/9/17.
//  Copyright © 2017 franktan. All rights reserved.
//

import Foundation
import UIKit

/**
 Per Spotify Docs, AlbumType is one of three values: album, single or compilation.

 AlbumType inherits `String` to allow `init(rawValue:)` and `AlbumType.rawValue`.
 */
enum AlbumType: String {
    case album, single, compilation
}

struct Album {
    /// One of three values: album, single, or compilation.
    let albumType: AlbumType

    /// Array of `Artist` objects, simplified to artist name for now.
    let artists: [String]

    /// Internal Spotify ID.
    let spotifyID: String

    /// The largest of Spotify's provided image sizes.
    let imageURL: URL

    /// Name of the album.
    let name: String

    /// Spotify URI for the album.
    let spotifyURI: String

    /// Album art.
    var image: UIImage?

    init(albumType: String,
         artists: [String],
         sID: String,
         imageURL: URL,
         name: String,
         sURI: String) {
        self.albumType = AlbumType(rawValue: albumType)!
        self.artists = artists
        self.spotifyID = sID
        self.imageURL = imageURL
        self.name = name
        self.spotifyURI = sURI
    }
}

// MARK: - JSON initializer

extension Album {
    static func initMultipleAlbums(data: Data) -> [Album]? {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return nil
        }

        guard let _d = json as? [String: Any],
            let d = _d["albums"] as? [String: Any],
            let albums = d["items"] as? [Any] else {
                return nil
        }

        var result: [Album] = []
        for case let albumDict as [String: Any] in albums {
            guard let album = Album(data: albumDict) else {
                return nil
            }
            result.append(album)
        }

        return result
    }

    init?(data: [String: Any]) {
        guard let albumType = data["album_type"] as? String,
            let artists = data["artists"] as? [[String: Any]],
            let artistNames = (artists.map { $0["name"] }) as? [String],
            let sID = data["id"] as? String,

            /*
             TODO: - Rewrite this later.
             Placeholder code to get the url of the first(largest) image.
            */
            let imageDicts = data["images"] as? [Any],
            let imageDict = imageDicts[0] as? [String: Any],
            let imageURL = imageDict["url"] as? String,

            let name = data["name"] as? String,
            let sURI = data["uri"] as? String else {
                return nil
        }

        self.init(albumType: albumType,
                  artists: artistNames,
                  sID: sID,
                  imageURL: URL(string: imageURL)!,
                  name: name,
                  sURI: sURI)
    }
}
