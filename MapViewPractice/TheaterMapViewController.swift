//
//  TheaterMapViewController.swift
//  MapViewPractice
//
//  Created by 이재희 on 1/15/24.
//

import UIKit
import MapKit
import CoreLocation

class TheaterMapViewController: UIViewController {
    
    @IBOutlet var filterBarButton: UIBarButtonItem!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var currentLocationButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var theaterList = TheaterList.mapAnnotations
    var theaterType: TheaterType = .전체보기

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        showAnnotation()
        
        locationManager.delegate = self
        checkDeviceLocationAuthorization()
    }
    
    @IBAction func filterBarButtonTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for type in TheaterType.allCases {
            alert.addAction(UIAlertAction(title: type.rawValue, style: .default, handler: { [weak self] _ in
                guard let self else { return }
                if theaterType != type {
                    theaterType = type
                    showAnnotation()
                }
            }))
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @IBAction func currentLocationButtonTapped(_ sender: UIButton) {
        checkDeviceLocationAuthorization()
    }
    
    func showAnnotation() {
        var list: [Theater] = []
        
        switch theaterType {
        case .메가박스, .롯데시네마, .CGV:
            list = theaterList.filter { $0.theaterType == self.theaterType }
        case .전체보기:
            list = theaterList
        }
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(list.map { $0.annotation })
    }
    
}

extension TheaterMapViewController {
    
    func configureUI() {
        filterBarButton.title = "Filter"
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "location.fill")
        currentLocationButton.configuration = config
    }
    
    func setRegion(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 20000, longitudinalMeters: 20000)
        mapView.setRegion(region, animated: true)
    }
    
}

extension TheaterMapViewController {
    
    func checkDeviceLocationAuthorization() {
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                let status: CLAuthorizationStatus
                
                if #available(iOS 14.0, *) {
                    status = self.locationManager.authorizationStatus
                } else {
                    status = CLLocationManager.authorizationStatus()
                }
                
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: status)
                }
                
            } else {
                DispatchQueue.main.async {
                    self.showLocationAlert()
                }
            }
        }
    }
    
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            let coordinate = CLLocationCoordinate2D(latitude: 37.654165, longitude: 127.049696)
            setRegion(coordinate: coordinate)
            showLocationAlert()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        default:
            print("Error")
        }
    }
}

extension TheaterMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            setRegion(coordinate: coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 씨드큐브 창동: 37.654165, 127.049696
        let coordinate = CLLocationCoordinate2D(latitude: 37.654165, longitude: 127.049696)
        setRegion(coordinate: coordinate)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
    }
    
}
