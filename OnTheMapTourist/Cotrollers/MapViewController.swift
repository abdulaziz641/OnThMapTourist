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
    
    private var rightBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handlePinEditing))
        return barButtonItem
    }()
    
    private var mainMapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let editPinsButton: UIButton = {
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
        setupMapView()
        setupNavigationBar()
    }
    
    fileprivate func setupMapView() {
        mainMapView.delegate = self
        mainMapView.isUserInteractionEnabled = true
        configureGesureRecognizer()
    }
    
    @objc private func handlePinEditing() {
        let layout = ColumnFlowLayout()
        let favoritePhotosVC = FavoritePhotosController(collectionViewLayout: layout)
        navigationController?.pushViewController(favoritePhotosVC, animated: true)
    }
    
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
    
    //MARK: UI Configuration
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.title = "On the Map Tourist"
    }
    
    private func setupLayout() {
        view.addSubview(mainMapView)
        view.addSubview(editPinsButton)
        NSLayoutConstraint.activate([
            mainMapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainMapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainMapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainMapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            editPinsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            editPinsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -44),
            
            ])
    }
    
    fileprivate func configureGesureRecognizer() {
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(HandleLongTap))
        longTapGesture.minimumPressDuration = 0.9
        mainMapView.addGestureRecognizer(longTapGesture)
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
}
