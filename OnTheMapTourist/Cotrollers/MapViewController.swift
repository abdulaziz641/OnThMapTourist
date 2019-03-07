//
//  MapViewController.swift
//  OnTheMapTourist
//
//  Created by Abdulaziz Alsaloum on 03/03/2019.
//  Copyright © 2019 Abdulaziz Alsaloum. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: properties
    private var rightBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handlePinEditing))
        return barButtonItem
    }()
    
    private var mainMapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let viewLikedPhotosButton: UIButton = {
        let button = UIButton(type: .custom)
        let buttonImage = UIImage(named: "likePhoto")
        button.contentMode = .scaleToFill
        button.setImage(buttonImage, for: .normal)
        button.addTarget(self, action: #selector(handlePinEditing), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    //MARK: UI Configuration
    fileprivate func setupLayout() {
        setupMapView()
        setupNavigationBar()
        setupMapView()
        setupLikeButton()
    }
    
    fileprivate func setupMapView() {
        mainMapView.delegate = self
        mainMapView.isUserInteractionEnabled = true
        configureGesureRecognizer()
        view.addSubview(mainMapView)
        
        NSLayoutConstraint.activate([
            mainMapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainMapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainMapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainMapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            ])
    }
    
    fileprivate func setupLikeButton() {
        view.addSubview(viewLikedPhotosButton)
        NSLayoutConstraint.activate([
            
            viewLikedPhotosButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            viewLikedPhotosButton.topAnchor.constraint(equalTo: mainMapView.bottomAnchor, constant: -74),
            ])
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.title = "On the Map Tourist"
    }
    
    fileprivate func configureGesureRecognizer() {
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(HandleLongTap))
        longTapGesture.minimumPressDuration = 0.9
        mainMapView.addGestureRecognizer(longTapGesture)
    }
    
    //MARK: Target functions
    @objc private func handlePinEditing() {
        let layout = ColumnFlowLayout()
        let favoritePhotosVC = FavoritePhotosController(collectionViewLayout: layout)
        navigationController?.pushViewController(favoritePhotosVC, animated: true)
    }
    
    @objc private func HandleLongTap(sender: UIGestureRecognizer){
        if sender.state == .began {
            let locationInView = sender.location(in: mainMapView)
            let locationOnMap = mainMapView.convert(locationInView, toCoordinateFrom: mainMapView)
            let pinLocation = CLLocationCoordinate2D(latitude: locationOnMap.latitude, longitude: locationOnMap.longitude)
            let pinToAdd = MKPointAnnotation()
            pinToAdd.coordinate = pinLocation
            mainMapView.addAnnotation(pinToAdd)
        }
    }
    
    //MARK: MapView delegate implementation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.isEnabled = true
            pinView?.animatesDrop = true
            pinView?.pinTintColor = .red
        }else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let layout = ColumnFlowLayout()
        let photosVc = PhotoAlbumCollectionViewController(collectionViewLayout: layout)
        photosVc.pinCoordinates = view.annotation?.coordinate
        navigationController?.pushViewController(photosVc, animated: true)
        mainMapView.deselectAnnotation(view.annotation, animated: true)
    }
}
