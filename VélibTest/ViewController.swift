//
//  ViewController.swift
//  VélibTest
//
//  Created by Arnaud Aubry on 02/12/2015.
//  Copyright © 2015 Arnaud Aubry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var stations = [Station]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Vélib"

        let cellNib = UINib(nibName: "StationTableViewCell", bundle: nil)
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: "stationCell")
        self.tableView.estimatedRowHeight = 58.0
        self.tableView.rowHeight = UITableViewAutomaticDimension

        Station.fetchStations { (stations) -> Void in
            self.stations = stations
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stations.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("stationCell", forIndexPath: indexPath) as! StationTableViewCell
        let station = self.stations[indexPath.row]

        cell.nameLabel?.text = station.name
        cell.addressLabel?.text = station.address
        cell.countLabel.text = ""

        Station.fetchStationsInfos(station) { (infos) -> Void in
            if let infos = infos {
                let availableBikes = infos["available_bikes"] as! Int
                let availableStands = infos["available_bike_stands"] as! Int

                cell.countLabel.text = "\(availableBikes)/\(availableStands)"
            }
        }
        return cell
    }
}