//
//  EventsViewController.swift
//  PDM2-Project
//
//  Created by JJM on 15/11/2022.
//

import UIKit

class EventsListVC: UIViewController {
    
    var tableView = UITableView()
    var events = [Result]()
    var specificEvent: Result! 
    
    struct Cells {
        static let eventCell = "EventCell"
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Events"
        fetchEvents()
        configureTableView()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 130
        tableView.register(EventCell.self, forCellReuseIdentifier: Cells.eventCell)
        tableView.pin(to: view)
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension EventsListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.eventCell) as! EventCell
        let event = events[indexPath.row]
        cell.set(event: event)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        specificEvent = events[indexPath.row]
        
        performSegue(withIdentifier: "EventVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let EventVC = segue.destination as? EventVC{
            EventVC.specificEvent = specificEvent
        }
    }
    
    func fetchEvents() {
        DispatchQueue.global(qos: .userInteractive).async {
            MarvelEvents.fetchAllComics() { (ResultsPage) in
                self.events = ResultsPage.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

extension MarvelEvents {
}
