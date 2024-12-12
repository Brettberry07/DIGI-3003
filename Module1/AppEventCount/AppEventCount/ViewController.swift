//
//  ViewController.swift
//  AppEventCount
//
//  Created by Berry, Brett A. (Student) on 10/17/24.
//

import UIKit

class ViewController: UIViewController {
    
    //outlets
    @IBOutlet var didFinishLauncingLabel: UILabel!
    @IBOutlet var configurationForConnecingLabel: UILabel!
    @IBOutlet var willConnectToLabel: UILabel!
    @IBOutlet var sceneDidBecomeActiveLabel: UILabel!
    @IBOutlet var sceneWillResignLabel: UILabel!
    @IBOutlet var sceneWillEnterForeground: UILabel!
    @IBOutlet var sceneDidEnterBackground: UILabel!
    
    //variables
    var appDelegate =  (UIApplication.shared.delegate as! AppDelegate)
    
    var willConnectCount = 0
    var sceneBecameActiveCount = 0
    var sceneWillResignCount = 0
    var sceneWillEnterForegroundCount = 0
    var sceneDidEnterBackgroundCount = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    func updateView(){
        //AppDelegate
        didFinishLauncingLabel.text = "The app has launched: \(appDelegate.launchCount) time(s)"
        configurationForConnecingLabel.text = "The app has configured connection \(appDelegate.configutationForConnectingCount) time(s)"
        
        //SceneDelegate
        willConnectToLabel.text = "The app has tried to connect \(willConnectCount) time(s)"
        sceneDidBecomeActiveLabel.text = "The scene has become active \(sceneBecameActiveCount) time(s)"
        sceneWillResignLabel.text = "The scene has resigned \(sceneWillResignCount) time(s)"
        sceneWillEnterForeground.text = "The scene has about to enter the foreground \(sceneWillEnterForegroundCount) time(s)"
        sceneDidEnterBackground.text = "The scene has entered the background  \(sceneDidEnterBackgroundCount) time(s)"
        
    }


}

