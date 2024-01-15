//
//  Theater.swift
//  MapViewPractice
//
//  Created by 이재희 on 1/15/24.
//

import MapKit

enum TheaterType: String, CaseIterable {
    case 메가박스
    case 롯데시네마
    case CGV
    case 전체보기
}

struct Theater {
    let type: String
    let location: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    
    var theaterType: TheaterType {
        TheaterType(rawValue: type)!
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var annotation: MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location
        return annotation
    }
}
