//
//  FavsVC.swift
//  PDM2-Project
//
//  Created by JDM on 24/01/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FavsVC: UIViewController {

    let eventsRef = Firestore.firestore().collection("events")
    var events: [[String: Any]] = []
    var eventsCount = 0
    var dataLoaded = false
    var eventImageView = UIImageView()
    
    var eventName = ""
    var eventThumbnailURL = ""
    var eventDescription = ""
    
    @IBOutlet weak var eventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.delegate = self
        eventTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        if let user = Auth.auth().currentUser {
            eventsRef.document(user.uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    self.events = document.data()?["events"] as? [[String:Any]] ?? []
                } else {
                    // No events found for the current user
                }
            }
        } else {
          // No user is signed in. Show the login screen or redirect the user to the login screen.
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: true)
        }
    }
}

extension FavsVC: UITableViewDelegate, UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !dataLoaded {
            if let user = Auth.auth().currentUser {
                eventsRef.document(user.uid).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let events = document.data()?["events"] as? [[String:Any]] ?? []
                        self.eventsCount = events.count
                        self.dataLoaded = true
                        tableView.reloadData()
                    } else {
                        // No events found for the current user
                    }
                }
            } else {
                // No user is signed in. Show the login screen or redirect the user to the login screen.
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
                vc?.modalPresentationStyle = .overFullScreen
                self.present(vc!, animated: true)
            }
        }
        return eventsCount
    }



    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventName = events[indexPath.row]["eventName"] as? String ?? ""
        eventThumbnailURL = events[indexPath.row]["eventThumbnail"] as? String ?? ""
        eventDescription = events[indexPath.row]["eventDescription"] as? String ?? ""
        
        performSegue(withIdentifier: "FavVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let FavVC = segue.destination as? FavVC{
            FavVC.eventName = eventName
            FavVC.eventThumbnailURL = eventThumbnailURL
            FavVC.eventDescription = eventDescription
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        cell.textLabel?.text = events[indexPath.row]["eventName"] as? String ?? ""
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        // Add an image view to the cell
        let eventImageView = UIImageView(frame: CGRect(x: self.view.frame.size.width - 60, y: 10, width: 50, height: 50))
        eventImageView.contentMode = .scaleAspectFit
        eventImageView.tag = indexPath.row
        
        // Get the event thumbnail URL
        let eventThumbnailUrl = events[indexPath.row]["eventThumbnail"] as? String ?? ""
        
        let httpseventThumbnailUrl = eventThumbnailUrl.replacingOccurrences(of: "http", with: "https")
        
        // Download the image data and set it to the image view
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: URL(string: httpseventThumbnailUrl)!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if eventImageView.tag == indexPath.row {
                            eventImageView.image = image
                        }
                    }
                }
            }
        }
        cell.addSubview(eventImageView)
        return cell
    }


}
