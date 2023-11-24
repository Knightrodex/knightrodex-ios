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
    let coordinate = CLLocationCoordinate2D(latitude: 28.6024, longitude: -81.2001)

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
        pin.title = "UCF Here"
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
        
        
        // Resize the image
        let customImage = UIImage(named: "ucf")
        let resizedImage = resizeImage(image: customImage, targetSize: CGSize(width: 40, height: 40))
        annotationView?.image = resizedImage
                
        return annotationView
    }
    
        // Function to resize an image
        func resizeImage(image: UIImage?, targetSize: CGSize) -> UIImage? {
            guard let image = image else {
                return nil
            }

            let size = image.size
            let widthRatio  = targetSize.width  / size.width
            let heightRatio = targetSize.height / size.height

            let newSize: CGSize
            if widthRatio > heightRatio {
                newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            } else {
                newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
            }

            let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage
        }
}
