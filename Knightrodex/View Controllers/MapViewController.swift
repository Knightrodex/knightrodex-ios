//
//  MapViewController.swift
//  Knightrodex
//
//  Created by Ramir Dalencour on 11/22/23.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    let map = MKMapView()
    
    // We can come here and just plug in the location...
    let coordinate = CLLocationCoordinate2D(latitude: 40.728, longitude: -74)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(map)
        map.frame = view.bounds
        
        
        // To zoom in specific region
        map.setRegion(MKCoordinateRegion(center: coordinate,
                                         span: MKCoordinateSpan(latitudeDelta: 0.1,
                                                                longitudeDelta: 0.1)),
                      animated: false)
        
        map.delegate = self
        
        addCustomPin()
    }
    
    
    
    private func addCustomPin() {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "Pokemon Here"
        pin.subtitle = "Go and catch them all"
        
        map.addAnnotation(pin)
    }
    
    // Map
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            // Create the view
            annotationView = MKAnnotationView(annotation: annotation,
                                              reuseIdentifier: "custom")
            
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        
        annotationView?.image = UIImage(named: "ucf")
        
        
        
        return annotationView
    }
    
}
