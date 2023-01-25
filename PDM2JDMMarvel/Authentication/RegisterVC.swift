//
//  RegisterVC.swift
//  PDM2-Project
//
//  Created by JDM on 23/01/2023.
//

import UIKit
import FirebaseAuth
import Firebase

class RegisterVC: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        if email.text?.isEmpty == true {
            print("You didn't fill email")
            return
        }
        
        if password.text?.isEmpty == true {
            print("You didn't fill password")
            return
        }
        
        register()
    }
    
    func register(){
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) {(authResult, error) in
            guard let user = authResult?.user, error == nil else {
                print("Error \(String(describing: error?.localizedDescription))")
                return
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: true)
        }
    }

}
