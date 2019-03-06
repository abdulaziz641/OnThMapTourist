//
//  FavoritePhotosController.swift
//  OnTheMapTourist
//
//  Created by Abdulaziz Alsaloum on 06/03/2019.
//  Copyright © 2019 Abdulaziz Alsaloum. All rights reserved.
//

import UIKit

private let reuseIdentifier = "favPhotoCell"

class FavoritePhotosController: UICollectionViewController {
    
    private var likedPhotos: [Photo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedPhotos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FavPhotoCell
        return cell
        
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Favorites"
        navigationItem.leftBarButtonItem?.title = "Photos"
    }
    
    fileprivate func setupCollectionView() {
        // Register cell classes
        collectionView!.register(FavPhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}
