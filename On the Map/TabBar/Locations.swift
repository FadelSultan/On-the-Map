//
//  MapVC+model.swift
//  On the Map
//
//  Created by fadel sultan on 11/2/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import SwiftyJSON


struct studentInformation {
    
    //    public
    static var isAddedLocations = false
    static var arrStudentInformation = [studentInformation]()
    
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
    
    
    private static func add(studint:studentInformation) {
        studentInformation.arrStudentInformation.append(studint)
    }
    
    private static func removeAll() {
        studentInformation.arrStudentInformation.removeAll()
    }
    
    static func getData(compilation:@escaping(_ error:Error?) -> Void){
        API.webService(url: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt") { (resultJson , error) in
            
            if error != nil {
                compilation(error)
                return
            }
            
            guard let arrayJson = resultJson?["results"].array else {return}
            removeAll()
            for row in arrayJson {
                if let student = studentInformation.init(json: row) {
                    add(studint: student)
                }
            }
            compilation( nil)
        }
    }
}
