//
//  MapVC.swift
//  On the Map
//
//  Created by fadel sultan on 11/2/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    //    outlet
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        loadPoints()
    }
    
    private func loadPoints() {
        cProgress.start(add: view)
        studentInformation.getData { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    cProgress.hide()
                    let alert = UIAlertController.alert(message: error.localizedDescription) {}
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                var annotations = [MKPointAnnotation]()
                for point in studentInformation.arrStudentInformation {
                    let lat = CLLocationDegrees(point.latitude)
                    let long = CLLocationDegrees(point.longitude)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = point.firstName
                    let last = point.lastName
                    let mediaURL = point.mediaURL
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
                self.mapView.addAnnotations(annotations)
                
                let center = CLLocationCoordinate2D(latitude: studentInformation.arrStudentInformation.last!.latitude, longitude: studentInformation.arrStudentInformation.last!.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))
                self.mapView.setRegion(region, animated: true)
                cProgress.hide()
            }
        }
    }
    
    private func openSearchLocation() {
        let navi = self.storyboard?.instantiateViewController(withIdentifier: "SearchLocation") as! SearchLocationVC
        self.navigationController?.pushViewController(navi, animated: true)
    }
    
    //    Actions
    @IBAction func btnAddNewLocation(_ sender: Any) {
        if studentInformation.isAddedLocations {
            let alert = UIAlertController(title: nil, message: "You have already posted a student location. Would you like to overwrite current location ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Overwrite", style: .destructive, handler: { (_) in
                self.openSearchLocation()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }else {
            openSearchLocation()
        }
    }
    
    @IBAction func btnRefreshData(_ sender: Any) {
        loadPoints()
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        API.deleteSession { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    let alert = UIAlertController.alert(message: error.localizedDescription) {}
                    self.present(alert, animated: true, completion: nil)
                    return
                }      
                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            }
        }
    }
    
}

// MARK:- MKMapViewDelegate
extension MapVC : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}
