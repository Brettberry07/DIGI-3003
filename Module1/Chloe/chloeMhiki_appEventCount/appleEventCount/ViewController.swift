//
//  ViewController.swift
//  appleEventCount
//
//  Created by Hunter, Chloe Mikhayla A. (Student) on 10/18/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var didFinishLaunchingLabel: UILabel!
    var didFinishCount = 0
    
    @IBOutlet var configurationForConnectingLabel: UILabel!
    var configurationForConnectionCount = 0
    
    @IBOutlet var willConnectLabel: UILabel!
    var willConnectedCount = 0
    
    @IBOutlet var sceneDidBecomeActiveLabel: UILabel!
    var sceneDidBecomeActiveCount = 0
    
    @IBOutlet var sceneWillResignActive: UILabel!
    var sceneWillResignActiveCount = 0
    
    @IBOutlet var sceneWIllEnterForegroundLabel: UILabel!
    var sceneWillEnterForegroundCount = 0
    
    @IBOutlet var sceneDidEnterBackgroundLabel: UILabel!
    var sceneDidEnterBackgroundCount = 0
    
    var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func updateView(){
        didFinishLaunchingLabel.text = "The App has launched \(appDelegate.launchCount) time(s)"
        configurationForConnectingLabel.text = "The App has configured connection \(appDelegate.configurationForConnectingCount) time(s)"
        
        willConnectLabel.text = "The App has connected \(willConnectedCount) time(s)"
        
        sceneDidBecomeActiveLabel.text = "The App has been active \(sceneDidBecomeActiveCount) time(s)"
        sceneWillResignActive.text = "The App has resigned being active \(sceneWillResignActiveCount) time(s)"
        sceneWIllEnterForegroundLabel.text = "The App has entered foreground \(sceneWillEnterForegroundCount) time(s)"
        sceneDidEnterBackgroundLabel.text = "The App has entered background \(sceneDidEnterBackgroundCount) time(s)"
        
        
    }
    
}
