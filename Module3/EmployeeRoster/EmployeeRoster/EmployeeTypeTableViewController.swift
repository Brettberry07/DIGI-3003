//
//  EmployeeTypeTableViewController.swift
//  EmployeeRoster
//
//  Created by Berry, Brett A. (Student) on 11/2/24.
//

import UIKit

protocol EmployeeTableViewControllerDelegate: AnyObject {
    func employeeTypeTableViewController(_ controller: EmployeeTypeTableViewController, didSelect employeeType: EmployeeType)
}

class EmployeeTypeTableViewController: UITableViewController, EmployeeTableViewControllerDelegate{
    func employeeTypeTableViewController(_ controller: EmployeeTypeTableViewController, didSelect employeeType: EmployeeType) {
        return
    }
    
    
    //keep track of currently selected employee type
    var employeeType: EmployeeType?
    
    weak var delegate: EmployeeTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EmployeeType.allCases.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            //getting the default cell layout
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeType", for: indexPath)
            //getting the employee type for the cell
            let type = EmployeeType.allCases[indexPath.row]
            
            //getting content of that cell so we can change it
            var content = cell.defaultContentConfiguration()
            content.text = type.description //changing the text
            cell.contentConfiguration = content //setting the content
            
            //setting the checkmark
            if employeeType == type{
                cell.accessoryType = .checkmark
            }
            else{
                cell.accessoryType = .none
            }
            
            return cell
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let selectedType = EmployeeType.allCases[indexPath.row]
            employeeType = selectedType
            
            delegate?.employeeTypeTableViewController(self, didSelect: selectedType)
            
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
