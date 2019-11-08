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
    
    //    arraies
    var locationsData = [LocationsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPoints()
    }
    
    private func loadPoints() {
        locationsData.removeAll()
        self.tableView.reloadData()
        LocationsData.getData { (points) in
            self.locationsData = points
            DispatchQueue.main.async {
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
}

//MARK:- UITableViewDataSource , UITableViewDelegate
extension ListVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.imageView?.image = UIImage(named: "icon_pin")
        let row = locationsData[indexPath.row]
        cell.textLabel?.text = "\(row.firstName) \(row.lastName)"
        return cell
    }
    
    
}
