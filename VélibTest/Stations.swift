//
//  Stations.swift
//  VélibTest
//
//  Created by Arnaud Aubry on 02/12/2015.
//  Copyright © 2015 Arnaud Aubry. All rights reserved.
//

import Foundation

struct Station {
    var name: String
    var identifier: Int
    var address: String

    static func fetchStations(completion: (stations: [Station]) -> Void) {
        let path = "\(API.baseURLString)\(API.stationEndpoint)?contract=Paris&apiKey=\(API.apiKey)"
        let url = NSURL(string: path)!
        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()

        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            var stations = [Station]()

            if let data = data {
                let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [[String: AnyObject]]

                for station in result {
                    let newStation = Station(name: station["name"] as! String, identifier: station["number"] as! Int, address: station["address"] as! String)
                    stations.append(newStation)
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(stations: stations)
            })
        }
        task.resume()
    }

    static func fetchStationsInfos(station: Station, completion: (infos: [String: AnyObject]?) -> Void) {
        let path = "\(API.baseURLString)\(API.stationEndpoint)/\(station.identifier)?contract=Paris&apiKey=\(API.apiKey)"
        let url = NSURL(string: path)!
        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let data = data {
                let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String: AnyObject]
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(infos: result)
                })
                return
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(infos: nil)
            })
        }
        task.resume()
    }
}