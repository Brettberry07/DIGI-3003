//
//  AthleteFormViewController.swift
//  FavoriteAthlete
//
//  Created by Hunter, Chloe Mikhayla. (Student) on 10/20/24.
//

import UIKit

class AthleteFormViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var leageTextField: UITextField!
    @IBOutlet var teamTextField: UITextField!
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let name = nameTextField.text,
            let ageString = ageTextField.text,
            let age = Int(ageString),
            let league = leageTextField.text,
            let team = teamTextField.text else {return}
        
            athlete = Athlete(name: name, age: age, league: league,
            team: team)
        performSegue(withIdentifier:"unwindedSegue", sender:self)
    }
    
    
    var athlete: Athlete?
    override func viewDidLoad() {
        updateView()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    init?(coder: NSCoder, athlete: Athlete) {
        self.athlete = athlete
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateView(){
        //check step 4 if all else fails
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
