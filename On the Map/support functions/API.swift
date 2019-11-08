//
//  API.swift
//  On the Map
//
//  Created by fadel sultan on 10/12/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import SwiftyJSON

class API {
    
    class func webService(url:String , httpBody:String = "" , isLogin:Bool = false ,  compilation:@escaping(_ json:JSON)->Void) {
        var request = URLRequest(url: URL(string: url)!)
        if !httpBody.isEmpty {
            request.httpMethod = "POST"
        }
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = httpBody.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print("error " , error!.localizedDescription)
                return
            }
            guard let data = data else {return}
            
            let range:Range = 5..<data.count
            
            let newData = data.subdata(in: range) /* subset response data! */
            compilation(JSON(!isLogin ? data : newData))
        }
        task.resume()
    }
}
