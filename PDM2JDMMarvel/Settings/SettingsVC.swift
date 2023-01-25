//
//  SettingsVC.swift
//  PDM2-Project
//
//  Created by JDM on 17/11/2022.
//

import UIKit
import UserNotifications

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func button(_ sender: Any) {
        let center = UNUserNotificationCenter.current()
            
        let content = UNMutableNotificationContent()
        content.title = "Marvel API"
        content.body = "Isto é uma notificação"
        
        let date = Date().addingTimeInterval(5)
        
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request) { (error) in
        }
    }
    
    
    @IBAction func darkModeSwitch(_ sender: UISwitch) {
        if sender.isOn {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
    

}
