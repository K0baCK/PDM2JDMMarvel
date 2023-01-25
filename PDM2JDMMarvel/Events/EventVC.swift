//
//  EventVC.swift
//  PDM2-Project
//
//  Created by JDM on 16/11/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EventVC: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var specificEvent: Result!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let event = specificEvent else {
            print("lol")
            return
        }
        
        titleLabel.text = event.title
        descriptionLabel.text = event.description
        
        let stringToImage = (event.thumbnail.path ?? "")+"."+(event.thumbnail.thumbnailExtension ?? "")
        let httpsStringToImage = stringToImage.replacingOccurrences(of: "http", with: "https")
        setImage(urlString: httpsStringToImage)
        
        
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        guard let event = specificEvent else {
            print("lol")
            return
        }
        let linkToShare = event.resourceURI
        let activityViewController = UIActivityViewController(activityItems: [linkToShare], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func favouritesButton(_ sender: Any) {
        
        guard let event = specificEvent else {
            print("lol")
            return
        }
        
        let eventsRef = Firestore.firestore().collection("events")
        if let user = Auth.auth().currentUser {
          // User is signed in.
            let eventName = event.title
            let eventThumbnail = (event.thumbnail.path ?? "")+"."+(event.thumbnail.thumbnailExtension ?? "")
            let eventDescription = event.description
            let eventToSave = ["eventName": eventName, "eventThumbnail": eventThumbnail, "eventDescription": eventDescription]
            
            eventsRef.document(user.uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    var events = document.data()?["events"] as? [[String:Any]] ?? []
                    let eventName = event.title
                    var isExist = false
                    for eventSaved in events {
                        if eventSaved["eventName"] as? String == eventName {
                            isExist = true
                            let alert = UIAlertController(title: "Error", message: "Event already saved", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                            self.present(alert, animated: true)
                            break
                        }
                    }
                    if !isExist {
                        events.append(eventToSave)
                        eventsRef.document(user.uid).updateData(["events": events]) { err in
                            if let err = err {
                                print("Error updating events: \(err)")
                                let alert = UIAlertController(title: "Error", message: "Already have it on Favourites", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                                self.present(alert, animated: true)
                            } else {
                                print("Events updated")
                                let alert = UIAlertController(title: "Success", message: "Event added to Favourites successfully", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                                self.present(alert, animated: true)
                            }
                        }
                    }
                } else {
                    eventsRef.document(user.uid).setData(["events": [eventToSave]]) { err in
                        if let err = err {
                            print("Error adding events: \(err)")
                            let alert = UIAlertController(title: "Error", message: "Error adding events", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                            self.present(alert, animated: true)
                        } else {
                            print("Events added with ID: \(user.uid)")
                            let alert = UIAlertController(title: "Success", message: "Event added to Favourites successfully", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                }
            }



        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: true)
        }


        
    }
    
    func setImage(urlString: String) {
        if let url = URL.init(string: urlString){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.img.image = UIImage(data: data!)
                }
            }
        }
    }

}
