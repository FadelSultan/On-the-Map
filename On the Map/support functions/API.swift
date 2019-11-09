//
//  API.swift
//  On the Map
//
//  Created by fadel sultan on 10/12/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import SwiftyJSON

struct API {
    
    
    
    static func webService(url:String , httpBody:String = "" , isLogin:Bool = false ,  compilation:@escaping(_ json:JSON? , _ error:Error?)->Void) {
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
                compilation(nil , error)
                return
            }
            guard let data = data else {return}
            
            let range:Range = 5..<data.count
            
            let newData = data.subdata(in: range) /* subset response data! */
//            print(String(data: newData, encoding: .utf8)!)
            
            compilation(JSON(!isLogin ? data : newData) , nil)
        }
        task.resume()
    }
    
    static func deleteSession( compilation:@escaping(_ error:Error?)->Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                compilation(error)
                return
            }
            guard let data = data else {return}
            let range:Range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
        }
        task.resume()
        compilation(nil)
    }
}
