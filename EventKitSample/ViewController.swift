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
    @IBOutlet weak var newEvent: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        
        eventManager.confirmAuthThen {
            self.tableView.reloadData()
        }
    }

    @IBAction func clickNewEvent(_ sender: Any) {
        self.eventManager.newEvent(title: "new event")
        self.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            eventManager.removeEvent(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
