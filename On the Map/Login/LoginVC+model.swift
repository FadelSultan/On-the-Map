//
//  LoginVC+API.swift
//  On the Map
//
//  Created by fadel sultan on 10/8/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

extension LoginVC {
    class model {
        class func signIn(email:String , password:String , compilation:@escaping(_ isLogin:Bool)-> Void) {
            let url = "https://onthemap-api.udacity.com/v1/session"
            let httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
            API.webService(url: url, httpBody: httpBody , isLogin:true) { (result) in
                compilation(result["account"]["registered"].boolValue)
            }
        }
    }
}
