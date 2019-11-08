//
//  MapVC+model.swift
//  On the Map
//
//  Created by fadel sultan on 11/2/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import SwiftyJSON


class LocationsData{
    
//    public
    static var isAddedLocations = false
    
//    variables
    var firstName:String
    var lastName:String
    var longitude:Double
    var latitude:Double
    var mapString:String
    var mediaURL:String
    
    init?(json:JSON) {
        guard let firstName = json["firstName"].string
            , let lastName = json["lastName"].string
            , let longitude = json["longitude"].double
            , let latitude = json["latitude"].double
            , let mapString = json["mapString"].string
            , let mediaURL = json["mediaURL"].string
            else {
            return nil
        }
        self.firstName = firstName
        self.lastName = lastName
        self.longitude = longitude
        self.latitude = latitude
        self.mapString = mapString
        self.mediaURL = mediaURL
    }
    
    
    class func getData(compilation:@escaping(_ result:[LocationsData]) -> Void){
        API.webService(url: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100") { (resultJson) in
            guard let arrayJson = resultJson["results"].array else {return}
            
            var locationsData = [LocationsData]()
            
            for row in arrayJson {
                if let point = LocationsData.init(json: row) {
                    locationsData.append(point)
                }
            }
            compilation(locationsData)
        }
    }
}
