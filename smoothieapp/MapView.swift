//
//  MapView.swift
//  smoothieapp
//
//  Created by Simeon Lam on 2/22/20.
//  Copyright © 2020 cs125. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView : View {
 
    var body : some View {
        LocationView()
    }
}

struct LocationView: UIViewRepresentable {
    
    
    var locationManager = CLLocationManager()

    func setupManager() {
          locationManager.desiredAccuracy = kCLLocationAccuracyBest
          locationManager.requestWhenInUseAuthorization()
          locationManager.requestAlwaysAuthorization()
    }

    func makeUIView(context: Context) -> MKMapView {
        setupManager()
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "Market"
        searchRequest.region = mapView.region
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }

            for item in response.mapItems {
                let latitude = item.placemark.location!.coordinate.latitude
                let longitude = item.placemark.location!.coordinate.longitude
                let place = MKPointAnnotation()
                place.title = item.name
                place.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                mapView.addAnnotation(place)
            }
        }

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

struct Market {
    let id : String
    let name : String
    let location: CLLocationCoordinate2D
}
