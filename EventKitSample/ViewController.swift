//
//  ViewController.swift
//  EventKitSample
//
//  Created by shinichi teshirogi on 2022/05/30.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    let eventManager = EventManager()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        
        eventManager.confirmAuthThen {
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventManager.numberOfEvents()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "basicStyleCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "basicStyleCell")
        }
        guard let cell = cell else { return UITableViewCell() }
        cell.textLabel!.text = eventManager.eventAt(row: indexPath.row)?.title
        cell.detailTextLabel!.text = eventManager.eventAt(row: indexPath.row)?.startDate.description
        return cell
    }
}
