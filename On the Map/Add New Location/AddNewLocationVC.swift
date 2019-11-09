//
//  AddNewLocationVC.swift
//  On the Map
//
//  Created by fadel sultan on 11/8/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import UIKit
import MapKit

class AddNewLocationVC: UIViewController {

//    outlet
    @IBOutlet weak var textFieldLinkToShare: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
//    variables
    var latitude:Double?
    var longitude:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addLocation()
    }
    
    private func addLocation() {
        guard let latitude = latitude , let longitude = longitude else {return}
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))
        mapView.setRegion(region, animated: true)
    }
    
    
    @IBAction func btnSaveLocation(_ sender: Any) {
        guard let latitude = latitude , let longitude = longitude , let mediaURL = textFieldLinkToShare.text , !mediaURL.isEmpty else {
            let alert = UIAlertController.alert(message: "Please Enter a Link to Share!") {
                self.textFieldLinkToShare.becomeFirstResponder()
            }
             present(alert, animated: true, completion: nil)
            return
        }
        let url = "https://onthemap-api.udacity.com/v1/StudentLocation"
        let httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Fadel\", \"lastName\": \"Sultan\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        
        API.webService(url: url , httpBody: httpBody) { (json , error) in
            if let error = error {
                let alert = UIAlertController.alert(message: error.localizedDescription) {}
                self.present(alert, animated: true, completion: nil)
                return
            }
            studentInformation.isAddedLocations = true
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
}


// MARK:- MKMapViewDelegate
extension AddNewLocationVC : MKMapViewDelegate{
    
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
