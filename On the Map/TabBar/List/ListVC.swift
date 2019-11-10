//
//  ListVC.swift
//  On the Map
//
//  Created by fadel sultan on 11/2/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import UIKit

class ListVC: UIViewController {
    
    //    outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPoints()
    }
    
    private func loadPoints() {
        studentInformation.getData { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    let alert = UIAlertController.alert(message: error.localizedDescription) {}
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func btnSearchLocation(_ sender: Any) {
        let navi = self.storyboard?.instantiateViewController(withIdentifier: "SearchLocation") as! SearchLocationVC
        self.navigationController?.pushViewController(navi, animated: true)
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

//MARK:- UITableViewDataSource , UITableViewDelegate
extension ListVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInformation.arrStudentInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.imageView?.image = UIImage(named: "icon_pin")
        let row = studentInformation.arrStudentInformation[indexPath.row]
        cell.textLabel?.text = "\(row.firstName) \(row.lastName)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let row = studentInformation.arrStudentInformation[indexPath.row]
        let app = UIApplication.shared
        guard let url = URL(string: row.mediaURL) else {
            let alert = UIAlertController.alert(message: "You have wrong in url \n \(row.mediaURL)") {}
            present(alert, animated: true, completion: nil)
            return
        }
        if !app.canOpenURL(url) {
            let alert = UIAlertController.alert(message: "Can't open \n \(row.mediaURL)") {}
            present(alert, animated: true, completion: nil)
            return
        }
        app.open(url, options: [:], completionHandler: nil)
    }
}
