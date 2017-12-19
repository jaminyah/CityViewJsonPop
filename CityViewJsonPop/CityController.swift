//
//  CityController.swift
//  CityViewJsonPop
//
//  Created by macbook on 12/17/17.
//  Copyright © 2017 Jaminya. All rights reserved.
//

import Foundation


class CityController:NSObject, URLSessionDelegate {
    
    // Create URLSession that uses a delegate
    private lazy var session: URLSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    private let JsonUrl = "http://cdn.jaminya.com/json/cities.json"
    
    // Public properties
    var cities: NSArray?
  
    func downloadJson(completion: @escaping ()->()) {
        // Debug
        print("In downloadJson")
        
        // Convert JsonURl string to type URL
        let sessionUrl = URL(string: JsonUrl)!

        let task = session.dataTask(with: sessionUrl) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
                if let data = data {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        
                        if let major_cities = json["major_cities"] as? NSArray {
                              self.cities = major_cities
                            
                            // debug
                            print("Debugging self.cities")
                            print(self.cities![0])
                        }
                    } catch let error as NSError {
                        print("Failed to parse: \(error.localizedDescription)")
                    }
                }
            }
            // Run completion handler
            completion()
        }
        task.resume()
    }

} // class
