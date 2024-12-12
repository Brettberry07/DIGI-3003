//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Berry, Brett A. (Student) on 11/17/24.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let minutesToPrepare: Int
    @IBOutlet weak var confirmationLabel: UILabel!
    
    init?(coder: NSCoder, minutesToPrepare: Int) {
        self.minutesToPrepare = minutesToPrepare
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        confirmationLabel.text = "Thank you for your order! Your wait time is approximately \(minutesToPrepare) minutes."
    }
    
    //IBSegues and IBActions
    
    

}
