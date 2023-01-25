//
//  FavVC.swift
//  PDM2JDMMarvel
//
//  Created by Miguel Carvalho on 25/01/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FavVC: UIViewController {
    
    var eventName: String?
    var eventThumbnailURL: String?
    var eventDescription: String?
    let eventsRef = Firestore.firestore().collection("events")

    @IBOutlet weak var eventThumbnail: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventTitle.text = eventName
        eventDesc.text = eventDescription
        let stringToImage = eventThumbnailURL
        let httpsStringToImage = stringToImage!.replacingOccurrences(of: "http", with: "https")
        setImage(urlString: httpsStringToImage)
    
        // Do any additional setup after loading the view.
    }
    
    func setImage(urlString: String) {
        if let url = URL.init(string: urlString){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.eventThumbnail.image = UIImage(data: data!)
                }
            }
        }
    }
}
