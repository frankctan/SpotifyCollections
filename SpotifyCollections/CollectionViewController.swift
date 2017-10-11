//
//  CollectionViewController.swift
//  SpotifyCollections
//
//  Created by Frank Tan on 10/10/17.
//  Copyright © 2017 franktan. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {

    /// CollectionView DataSource.
    var dataSource: [Album?] = Array(repeating: nil, count: 20)

    private let albumViewCellReuseID = "albumViewCell"

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let itemsPerRow: CGFloat = 2
        let itemsPerColumn: CGFloat = 3
        let minSpacing: CGFloat = 5
        let horizontalPadding: CGFloat = 10

        let dim = UIScreen.main.bounds.width / itemsPerRow - minSpacing - horizontalPadding
        let itemSize = CGSize(width: dim, height: dim)

        layout.sectionInset = UIEdgeInsets(top: 0.0,
                                           left: horizontalPadding / 2,
                                           bottom: 0,
                                           right: horizontalPadding / 2)
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = minSpacing
        layout.minimumLineSpacing = minSpacing

        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = .white
        // Register cell class
        self.collectionView?.register(UINib.init(nibName: "AlbumViewCell", bundle: nil),
                                      forCellWithReuseIdentifier: self.albumViewCellReuseID)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
            collectionView
                .dequeueReusableCell(withReuseIdentifier: self.albumViewCellReuseID,
                                     for: indexPath) as! AlbumViewCell

        cell.album = self.dataSource[indexPath.row]
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

// MARK: - UIScrollViewDelegate
extension CollectionViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Total height of scroll view.
        let totalHeight = scrollView.contentSize.height

        // Return if collectionView isn't populated.
        guard totalHeight != 0 else {
            return
        }

        // Lower bounds of scroll position.
        let scrollPosition = scrollView.contentOffset.y + scrollView.bounds.height

        // Percentage of `totalHeight`
        let scrollThreshold: CGFloat = 0.8

        // If scrollPosition exceeds `scrollThreshold`, double the size of the dataSource.
        // TODO: - check Spotify API limit. For new releases, limit is 500.
        if scrollPosition > (scrollThreshold * totalHeight) {
            let placeholders: [Album?] = Array.init(repeating: nil, count: self.dataSource.count)

            var indexPaths: [IndexPath] = []
            for i in self.dataSource.count..<self.dataSource.count + placeholders.count {
                indexPaths.append(IndexPath(item: i, section: 0))
            }

            self.dataSource.append(contentsOf: placeholders)
            self.collectionView?.insertItems(at: indexPaths)
        }
    }
}
