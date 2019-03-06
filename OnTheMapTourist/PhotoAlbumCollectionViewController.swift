//
//  PhotoAlbumCollectionViewController.swift
//  OnTheMapTourist
//
//  Created by Abdulaziz Alsaloum on 03/03/2019.
//  Copyright © 2019 Abdulaziz Alsaloum. All rights reserved.
//

import UIKit
import MapKit

private let reuseIdentifier = "photoAlbCell"

class PhotoAlbumCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let photos: [Photo] = [
        Photo(name: "200_Image", data: nil, height: 40, width: 40, isLiked: true),
        Photo(name: "200_Image", data: nil, height: 20, width: 20, isLiked: false),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: true),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: true),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: true),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: false),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: true),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: true),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: true),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: true),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: true),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: false),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: true),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: true),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: true),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: true),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: false),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: true),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: true),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: false),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: true),
        Photo(name: "200_Image", data: nil, height: 10, width: 10, isLiked: false)]
    
    private var rightBarButtonItem: UIBarButtonItem!
    
    var pinCoordinates: CLLocationCoordinate2D! {
        didSet {
            print("Received a new pin with coordinates: \(pinCoordinates.latitude), \(pinCoordinates.longitude)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNavigationBar()
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrCell
        // Configure the cell
        cell.photo = photos[indexPath.item]
        
        return cell
    }
    
    //MARK: UI COnfiguration
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(viewFavorites))
        navigationItem.rightBarButtonItem?.image = UIImage(named: "deslikePhoto")
    }
    
    @objc func viewFavorites() {
        let layout = ColumnFlowLayout()
        let favoritePhotosVC = FavoritePhotosController(collectionViewLayout: layout)
        navigationController!.pushViewController(favoritePhotosVC, animated: true)
    }
    
    fileprivate func setupCollectionView() {
        // Register cell classes
        collectionView!.register(FlickrCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}
