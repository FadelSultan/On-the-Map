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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func searchLocation(textSearch:String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = textSearch
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            
            if let error = error {
                print("Error " , error.localizedDescription)
                return
            }
            
            let latitude = response?.boundingRegion.center.latitude
            let longitude = response?.boundingRegion.center.longitude
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNewLocation") as! AddNewLocationVC
            vc.latitude = latitude
            vc.longitude = longitude
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func btnSearchLocaion(_ sender: Any) {
        guard let textSearch = textFieldSearch.text , !textSearch.isEmpty else {
            print("Please insert text search !")
            return
        }
        searchLocation(textSearch: textSearch)
    }
    
    
    @IBAction func btnCloseVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
