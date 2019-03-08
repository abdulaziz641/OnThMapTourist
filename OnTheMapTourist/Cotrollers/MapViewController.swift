//
//  MapViewController.swift
//  OnTheMapTourist
//
//  Created by Abdulaziz Alsaloum on 03/03/2019.
//  Copyright © 2019 Abdulaziz Alsaloum. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: properties
    private var rightBarButtonItem: UIBarButtonItem!
    
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
        button.addTarget(self, action: #selector(viewFavorites), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let deletePinButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Delete Pin", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.isHidden = true
//        button.addTarget(self, action: #selector(), for: .touchUpInside)
        return button
    }()
    
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Pin>!
    var isEditingPins: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupFetchedResultsController()
        addPinsToMap()
        setupLayout()
    }
    
    //MARK: UI Configuration
    fileprivate func setupLayout() {
        setupMapView()
        setupNavigationBar()
        setupMapView()
        setupLikeButton()
        setupDeletePinButton()
    }
    
    fileprivate func setupDeletePinButton() {
        view.addSubview(deletePinButton)
        
        NSLayoutConstraint.activate([
            deletePinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deletePinButton.heightAnchor.constraint(equalToConstant: 44),
            deletePinButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            deletePinButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
            
            ])
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
            mainMapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
        let editPinsButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setTitle("Edit", for: .normal)
            button.setTitleColor( .blue, for: .normal)
            button.addTarget(self, action: #selector(handlePinsEditing), for: .touchUpInside)
            return button
        }()
        
        rightBarButtonItem = UIBarButtonItem(customView: editPinsButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.title = "On the Map Tourist"
    }
    
    fileprivate func configureGesureRecognizer() {
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(HandleLongTap))
        longTapGesture.minimumPressDuration = 0.9
        mainMapView.addGestureRecognizer(longTapGesture)
    }
    
    func addPinsToMap() {
        var loadedPins: [MKPointAnnotation] = []
        for pin in fetchedResultsController?.fetchedObjects ?? [] {
            let pinLocation = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            let pinToAdd = MKPointAnnotation()
            pinToAdd.coordinate = pinLocation
            loadedPins.append(pinToAdd)
        }
        mainMapView.addAnnotations(loadedPins)
    }
    
    //MARK: Target functions
    @objc func viewFavorites() {
        let layout = ColumnFlowLayout()
        let favoritePhotosVC = FavoritePhotosController(collectionViewLayout: layout)
        favoritePhotosVC.dataController = dataController
        navigationController!.pushViewController(favoritePhotosVC, animated: true)
    }
    
    @objc func handlePinsEditing() {
        isEditingPins = !isEditingPins
        if isEditingPins {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handlePinsEditing))
            deletePinButton.isHidden = false
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handlePinsEditing))
            deletePinButton.isHidden = true
        }
    }
    
    @objc private func HandleLongTap(sender: UIGestureRecognizer){
        if sender.state == .began {
            let locationInView = sender.location(in: mainMapView)
            let locationOnMap = mainMapView.convert(locationInView, toCoordinateFrom: mainMapView)
//            let pinLocation = CLLocationCoordinate2D(latitude: locationOnMap.latitude, longitude: locationOnMap.longitude)
//            let pinToAdd = MKPointAnnotation()
//            pinToAdd.coordinate = pinLocation
            createNewPin(coordinates: locationOnMap)
//            mainMapView.addAnnotation(pinToAdd)
        }
    }
    
    //MARK: fetch request
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let viewContext = dataController.viewContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: viewContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: "pins")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            showAlert(title: "Fetching Failure", message: "The fetch could not be performed.", buttonText: "Ok")
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
        if !isEditingPins {
            let layout = ColumnFlowLayout()
            let photosVc = PhotoAlbumCollectionViewController(collectionViewLayout: layout)
            photosVc.pinCoordinates = view.annotation?.coordinate
            photosVc.dataController = dataController
            navigationController?.pushViewController(photosVc, animated: true)
            mainMapView.deselectAnnotation(view.annotation, animated: true)
            } else {
            if let lat = view.annotation?.coordinate.latitude,
                let lon = view.annotation?.coordinate.longitude {
                removePin(lat: lat, long: lon)
            }
        }
    }
    
    //MARK: Creating a new Pin
    func createNewPin(coordinates: CLLocationCoordinate2D) {
        let newPin = Pin(context: dataController.viewContext)
        newPin.latitude = coordinates.latitude
        newPin.longitude = coordinates.longitude
        newPin.creationDate = Date()
        try! dataController.viewContext.save()
    }
    
    //MARK: remove a Pin from store
    func removePin(lat: Double, long: Double) {
        let pinToDelete = loadPin(lat: lat, long: long)!
        dataController.viewContext.delete(pinToDelete)
        try! dataController.viewContext.save()
    }
    
    //MARK: load pin from store
    func loadPin(lat: Double, long: Double) -> Pin? {
        return fetchedResultsController.fetchedObjects?.first(where: { $0.latitude == lat && $0.longitude == long})
    }
}

extension MapViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard let pin = anObject as? Pin else {
            showAlert(title: "Error", message: "Unable to case anyObject to Pin", buttonText: "OK")
            return
        }
        
        switch type {
        case .insert:
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = pin.latitude
            annotation.coordinate.longitude = pin.longitude
            mainMapView.addAnnotation(annotation)
            
        case .delete:
            let annotationToDelete = mainMapView.selectedAnnotations[0]
            mainMapView.removeAnnotation(annotationToDelete)
            mainMapView.deselectAnnotation(annotationToDelete, animated: true)
        case .update: break
        case .move: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert: break
        case .delete: break
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}
}
