//
//  CityController.swift
//  CityViewJsonPop
//
//  Created by macbook on 12/17/17.
//  Copyright © 2017 Jaminya. All rights reserved.
//

import Foundation

struct City {
    let flagUrl: String?
    let slug:String?
    let sports_team: String?
    let city: String?
    let state: String?
    let region: String?
    let latitude: Double?
    let longitude: Double?
}


class CityController:NSObject, URLSessionDelegate {
    
    // Create URLSession that uses a delegate
    private lazy var session: URLSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    private let JsonUrl = "http://cdn.jaminya.com/json/cities.json"
    
    // Public properties
    var cities = [City]()
  
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
                            
                            self.buildCitiesFrom(jsonArray: major_cities)
                            
                            // debug
                            print("Debugging self.cities")
                            print(major_cities[0])
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
    
    private func buildCitiesFrom(jsonArray:NSArray?) {
        self.cities.removeAll()
        var index = 0
        if let cityArray = jsonArray {
            while (index < cityArray.count) {
                let city = cityArray[index] as? NSDictionary
                let flagLink = city?["flagUrl"] as? String
                let slugName = city?["slug"] as? String
                let team = city?["sports_team"] as? String
                let cityName = city?["city"] as? String
                let stateName = city?["state"] as? String
                let regionName = city?["region"] as? String
                let lat = city?["latitude"] as? Double
                let long = city?["longitude"] as? Double
                self.cities.append(City(flagUrl:flagLink, slug:slugName, sports_team:team,
                                        city:cityName, state:stateName, region:regionName, latitude:lat, longitude:long))
                index = index + 1
            }
        }
    }

} // class
