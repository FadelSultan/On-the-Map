//
//  Extension+AlertController.swift
//  On the Map
//
//  Created by fadel sultan on 10/8/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
   class func alert(message:String , action:@escaping()->Void) -> UIAlertController {
        
        let alert = UIAlertController(title: "Oopz!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (_) in
            action()
        }))
    return alert
    }
}
