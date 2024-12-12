//
//  FoodTableViewController.swift
//  MealTracker
//
//  Created by Berry, Brett A. (Student) on 10/24/24.
//

import UIKit

class FoodTableViewController: UITableViewController {
    
    //outlets
    
    //variables
    var meals: [Meal] {
        let breakfast: Meal = Meal(name: "Breakfast", food: [Food(name: "Cereal", description: "Very sweet"), Food(name: "Milk", description: "In the cereal")])
        let lunch: Meal = Meal(name: "Lunch", food: [Food(name: "Mac and Cheese", description: "Cheesy and tasty"), Food(name: "Sandwich", description: "A tasty sandwich")])
        let dinner: Meal = Meal(name: "Dinner", food: [Food(name: "Steak", description: "Extremely good")])
        return [breakfast, lunch, dinner]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals[section].food.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Food", for: indexPath)
        
        let foodItem = meals[indexPath.section].food[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = foodItem.name
        content.secondaryText = foodItem.description
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return meals[section].name
    }
}
