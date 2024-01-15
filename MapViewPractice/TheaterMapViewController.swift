//
//  TheaterMapViewController.swift
//  MapViewPractice
//
//  Created by 이재희 on 1/15/24.
//

import UIKit
import MapKit

class TheaterMapViewController: UIViewController {
    
    @IBOutlet var filterBarButton: UIBarButtonItem!
    @IBOutlet var mapView: MKMapView!
    
    var theaterList = TheaterList.mapAnnotations
    var theaterType: TheaterType = .전체보기

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        showAnnotation()
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
        
        let coordinate = CLLocationCoordinate2D(latitude: 37.554921, longitude: 126.970345)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 20000, longitudinalMeters: 20000)
        mapView.setRegion(region, animated: true)
    }
    
}
