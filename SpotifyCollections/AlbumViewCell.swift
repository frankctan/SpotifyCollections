//
//  AlbumView.swift
//  SpotifyCollections
//
//  Created by Frank Tan on 10/10/17.
//  Copyright © 2017 franktan. All rights reserved.
//

import UIKit

class AlbumViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var album: Album? {
        didSet {
            self.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.blue.withAlphaComponent(0.8)
        // Apply a text shadow to make white text stand out on variable color album art.
        self.artistLabel.applyShadow()
        self.albumLabel.applyShadow()

        // Customize activityIndicator
        self.activityIndicator.hidesWhenStopped = true

        // Round corners for all views.
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.reloadData()
    }

    // Nil out and reset views
    override func prepareForReuse() {
        super.prepareForReuse()
        self.album = nil
        self.imageView.image = nil
        self.artistLabel.text = ""
        self.albumLabel.text = ""
        self.toggleViewsIfNeeded()
    }

    func reloadData() {
        guard let album = self.album else {
            self.toggleViewsIfNeeded()
            return
        }

        self.imageView.image = album.image
        self.artistLabel.text = album.formattedArtist
        self.albumLabel.text = album.name

        self.toggleViewsIfNeeded()
        self.setNeedsLayout()
    }

    func toggleViewsIfNeeded() {
        let flag = (album == nil)
        self.imageView.isHidden = flag
        self.artistLabel.isHidden = flag
        self.albumLabel.isHidden = flag
        if flag {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
}
