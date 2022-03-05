//
//  ViewController.swift
//  PracticeApp
//
//  Created by Danny Tsang on 3/3/22.
//

import CoreLocation
import MapKit
import UIKit

class MainViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    private var followFlag = true {
        didSet {
            followButton.configuration?.title = "Follow \(followFlag ? "On" : "Off")"
        }
    }
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.accessibilityIdentifier = "ViewController.MapView"
        return mapView
    }()
    
    
    private lazy var searchButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        button.accessibilityIdentifier = "ViewController.SearchButton"
        return button
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.title = "Follow On"
        button.addTarget(self, action: #selector(toggleFollowTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "ViewController.FollowButton"
        return button
    }()
    
    private lazy var zoomInButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.title = "+"
        button.addTarget(self, action: #selector(zoomInTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "ViewController.ZoomInButton"
        return button
    }()
    
    private lazy var zoomOutButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.title = "-"
        button.addTarget(self, action: #selector(zoomOutTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "ViewController.ZoomOutButton"
        return button
    }()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Main View"
        view.backgroundColor = UIColor.white
        
        configureView()
        setupMapView()
    }

    func configureView() {
        navigationItem.rightBarButtonItem = searchButton

        view.addSubview(mapView)
        view.addSubview(zoomInButton)
        view.addSubview(zoomOutButton)
        view.addSubview(followButton)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            zoomOutButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            zoomOutButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),

            zoomInButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            zoomInButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
            
            followButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            followButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
        ])
        
    }
    
    func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        // Setup CLLocation Manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    }

    // MARK: - Button Actions
    @objc func searchButtonTapped() {
        followFlag = false
        
        let vc = LookupAddressViewController(region: mapView.region)
        let navController = UINavigationController(rootViewController: vc)
        vc.modalPresentationStyle = .automatic
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func toggleFollowTapped() {
        followFlag = !followFlag
        
        if followFlag == true {
            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        }
    }
    
    @objc func zoomInTapped() {
        locationManager.stopUpdatingLocation()
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)

        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now()+3) {
            self.locationManager.startUpdatingLocation()
        }

    }
    
    @objc func zoomOutTapped() {
        locationManager.stopUpdatingLocation()
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)

        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now()+3) {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - MapView Delegate Methods
    
    
    // MARK: - CLLocationManger Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        if followFlag == true {
            mapView.setCenter(location.coordinate, animated: true)
        }
    }
    
    
}

