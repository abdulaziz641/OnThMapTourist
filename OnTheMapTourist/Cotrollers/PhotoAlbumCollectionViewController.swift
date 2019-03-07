//
//  PhotoAlbumCollectionViewController.swift
//  OnTheMapTourist
//
//  Created by Abdulaziz Alsaloum on 03/03/2019.
//  Copyright © 2019 Abdulaziz Alsaloum. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher

private let reuseIdentifier = "photoAlbCell"

class PhotoAlbumCollectionViewController: UICollectionViewController {
    
    //MARK: Properties
    var images: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private var rightBarButtonItem: UIBarButtonItem!
    var pinCoordinates: CLLocationCoordinate2D!
    
    private var internetIndicator: UIActivityIndicatorView = {
        let iv = UIActivityIndicatorView()
        iv.color = .gray
        iv.startAnimating()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var fetchingImagesLabel: UILabel = {
       let label = UILabel()
        label.text = "Fetcheing Images"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        fetchImages()
    }
    
    //MARK: UI Configuration
    fileprivate func setupLayout() {
        setupInternetIndicator()
        setupCollectionView()
        setupNavigationBar()
    }
    
    fileprivate func setupNavigationBar() {
        let favoritesButton: UIButton = {
            let button = UIButton(type: .custom)
            button.addTarget(self, action: #selector(viewFavorites), for: .touchUpInside)
            let imageView = UIImage(named: "likePhoto")
            button.setImage(imageView, for: .normal)
            return button
        }()
        rightBarButtonItem = UIBarButtonItem(customView: favoritesButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.title = "Photos"
        navigationItem.leftBarButtonItem?.title = "Map"
    }
    
    fileprivate func setupInternetIndicator() {
        let fetchingStackView = UIStackView(arrangedSubviews: [internetIndicator, fetchingImagesLabel])
        fetchingStackView.axis = .vertical
        fetchingStackView.alignment = .center
        fetchingStackView.distribution = .fill
        fetchingStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fetchingStackView)
        
        NSLayoutConstraint.activate([
            fetchingStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchingStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            ])
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
    
    fileprivate func configurUI(for code: UICode) {
        switch code {
        case .loaded:
            DispatchQueue.main.async {
                self.internetIndicator.stopAnimating()
                self.internetIndicator.isHidden = true
                self.fetchingImagesLabel.isHidden = true
            }
        case .emptyImagesInLocation:
            DispatchQueue.main.async {
                self.fetchingImagesLabel.text = "No images Found, try another location."
                self.fetchingImagesLabel.isHidden = false
            }
        }
    }
    
    //MARK: target functions
    @objc func viewFavorites() {
        let layout = ColumnFlowLayout()
        let favoritePhotosVC = FavoritePhotosController(collectionViewLayout: layout)
        navigationController!.pushViewController(favoritePhotosVC, animated: true)
    }
    
    //MARK: Image Fetching
    fileprivate func fetchImages() {
        NetworkClient.searchForImageFromFlickr(nil, lat: pinCoordinates.latitude, long: pinCoordinates.longitude) { (isSucceeded, _, _, listOfPhotosUrls) in
            if isSucceeded {
                self.configurUI(for: .loaded)
                
                if listOfPhotosUrls!.isEmpty {
                    self.configurUI(for: .emptyImagesInLocation)
                } else {
                    self.images = listOfPhotosUrls!
                }
//                for url in listOfPhotosUrls ?? [] {
//                    self.createNewPhoto(for: self.loadedPinFromStore, and: url)
//                }
            } else {
                DispatchQueue.main.async {
                    let alertController: UIAlertController = {
                       let alert = UIAlertController(title: "Network Error", message: "Check your internet connection.", preferredStyle: .alert)
                        let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: { (action) in
                            self.fetchImages()
                        })
                        alert.addAction(tryAgainAction)
                        return alert
                    }()
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return images.count }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrCell
        // Configure the cell
        //        cell.photo = photos[indexPath.item]
        let url = URL(string: images[indexPath.item])
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: url)
        return cell
    }
}
