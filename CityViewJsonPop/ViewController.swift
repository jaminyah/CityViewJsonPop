//
//  ViewController.swift
//  CityViewJsonPop
//
//  Created by macbook on 12/17/17.
//  Copyright © 2017 Jaminya. All rights reserved.
//

import UIKit

// Global constants
struct Constants {
    static let kNumberOfSections = 1
}


class ViewController: UIViewController {

    @IBOutlet weak var CityTableView: UITableView!
    let cellIdentifier = "CellIdentifier"
    var cityController = CityController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cityController.downloadJson(completion: reloadTable)
        print("Download complete in viewDidLoad")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTable() -> () {
        DispatchQueue.main.async {
            self.CityTableView.reloadData()
            print("Reload complete")
        }
    }
}


extension ViewController:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.kNumberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Before download function returns city count is nil so set to 16 rows
        if let cityCount = self.cityController.cities {
            return cityCount.count
        } else {
            return 16
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(
                style: UITableViewCellStyle.default,
                reuseIdentifier: cellIdentifier
            )
        }
        
        if let cityObject = self.cityController.cities?[indexPath.row] as? NSDictionary {
            cell?.textLabel?.text = cityObject["city"] as? String
        } else {
            cell?.textLabel?.text = "city_text"
        }

        return cell!
    }
}
