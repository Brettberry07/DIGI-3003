//
//  ViewController.swift
//  Contest
//
//  Created by Berry, Brett A. (Student) on 11/8/24.
//

import UIKit

class ViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var emailAdressField: UITextField!
    
    
    //variables
    
    //overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //functions
    
    //segues and actions
    @IBAction func onSubmitPress(_ sender: Any) {
        if ((emailAdressField.text?.isEmpty) != false) {
            self.emailAdressField.layer.borderColor = UIColor.red.cgColor
            self.emailAdressField.layer.borderWidth = 1
            UIView.animate(withDuration: 0.1, animations: {
                self.emailAdressField.transform = CGAffineTransform(translationX: 10, y: 0)
            }) { _ in
                UIView.animate(withDuration: 0.1, animations: {
                    self.emailAdressField.transform = CGAffineTransform(translationX: -10, y: 0)
                }) { _ in
                    UIView.animate(withDuration: 0.1) {
                        self.emailAdressField.layer.borderColor = UIColor.clear.cgColor
                        self.emailAdressField.layer.borderWidth = 0
                        self.emailAdressField.transform = .identity
                    }
                }
            }
        }
        else {
            performSegue(withIdentifier: "toConfirmation", sender: nil)
        }
        
    }
    

}

