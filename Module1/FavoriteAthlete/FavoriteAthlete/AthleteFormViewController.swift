//
//  AthleteFormViewController.swift
//  FavoriteAthlete
//
//  Created by Berry, Brett A. (Student) on 10/19/24.
//

import UIKit

class AthleteFormViewController: UIViewController {
    
    //outlets
    @IBOutlet var nameField: UITextField!
    @IBOutlet var ageField: UITextField!
    @IBOutlet var leagueField: UITextField!
    @IBOutlet var teamField: UITextField!
    
    var athlete: Athlete?
    
    init?(coder: NSCoder, athlete: Athlete?){
        self.athlete = athlete
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateView()
    }
    
    func updateView(){
        
    }
    
    @IBAction func onSaveSubmit(_ sender: Any) {
        guard let name = nameField.text,
              let ageString = ageField.text,
              let age = Int(ageString),
              let league = leagueField.text,
              let team = teamField.text else { return }
        
        athlete = Athlete(name: name, age: age, league: league, team: team)
        performSegue(withIdentifier: "onSubmitUnwind", sender: sender)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
