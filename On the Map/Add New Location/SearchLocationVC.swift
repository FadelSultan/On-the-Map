//
//  addNewLocationVC.swift
//  On the Map
//
//  Created by fadel sultan on 11/8/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import UIKit
import MapKit

class SearchLocationVC: UIViewController {

//    outlet
    @IBOutlet weak var textFieldSearch: UITextField!
        
    private func searchLocation(textSearch:String) {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = textSearch
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        cProgress.start(add: view, text: "Searching ...")
        activeSearch.start { (response, error) in
            
            if let error = error {
                cProgress.hide()
                let alert = UIAlertController.alert(message: error.localizedDescription) {}
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let latitude = response?.boundingRegion.center.latitude
            let longitude = response?.boundingRegion.center.longitude
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNewLocation") as! AddNewLocationVC
            vc.latitude = latitude
            vc.longitude = longitude
            self.navigationController?.pushViewController(vc, animated: true)
            cProgress.hide()
        }
    }

    @IBAction func btnSearchLocaion(_ sender: Any) {
        guard let textSearch = textFieldSearch.text , !textSearch.isEmpty else {
            let alert = UIAlertController.alert(message: "Please write text search!") {
                self.textFieldSearch.becomeFirstResponder()
            }
            self.present(alert, animated: true, completion: nil)
            return
        }
        searchLocation(textSearch: textSearch)
    }
    
    
    @IBAction func btnCloseVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
