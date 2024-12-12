
import UIKit

protocol EmployeeDetailTableViewControllerDelegate: AnyObject {
    func employeeDetailTableViewController(_ controller: EmployeeDetailTableViewController, didSave employee: Employee)
}

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate, EmployeeTableViewControllerDelegate {
    
    //conforming to protocol
    func employeeTypeTableViewController(_ controller: EmployeeTypeTableViewController, didSelect employeeType: EmployeeType) {
        self.employeeType = employeeType
        employeeTypeLabel.text = employeeType.description
        employeeTypeLabel.textColor = .black
        updateSaveButtonState()
        
        navigationController?.popViewController(animated: true)
    }
    

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var employeeTypeLabel: UILabel!
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var dobDatePicker: UIDatePicker!
    
    weak var delegate: EmployeeDetailTableViewControllerDelegate?
    var employee: Employee?
    
    var employeeType: EmployeeType?
    
    //property for dobDatePicker clicked on
    var isEditingDob: Bool = false{
        didSet{
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        updateSaveButtonState()
        
        dobDatePicker.addTarget(self, action: #selector(dobDateChanged), for: .valueChanged)
    }
    
    func updateView() {
        if let employee = employee {
            navigationItem.title = employee.name
            nameTextField.text = employee.name
            
            dobLabel.text = employee.dateOfBirth.formatted(date: .abbreviated, time: .omitted)
            dobLabel.textColor = .label
            employeeTypeLabel.text = employee.employeeType.description
            employeeTypeLabel.textColor = .label
        } else {
            navigationItem.title = "New Employee"
        }
    }
    
    private func updateSaveButtonState() {
        let shouldEnableSaveButton = nameTextField.text?.isEmpty == false && employeeType != nil
        saveBarButtonItem.isEnabled = shouldEnableSaveButton
    }
    
    //toggling the visibility of the dobPicker when dobLabel is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            isEditingDob.toggle()
            dobLabel.textColor = isEditingDob ? .label : .secondaryLabel
            dobLabel.text = isEditingDob ? "Select Date" : employee?.dateOfBirth.formatted(date: .abbreviated, time: .omitted)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // have to specify the height we need, since we have constraints we cna just return the automatic height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 2 {
            return isEditingDob ? UITableView.automaticDimension : 0
        }
        return UITableView.automaticDimension
    }
    
    //have to update the label text
    @objc func dobDateChanged() {
        let selectedDate = dobDatePicker.date
        dobLabel.text = selectedDate.formatted(date: .abbreviated, time: .omitted)
        dobLabel.textColor = .label
    }

    //have to change the saveButtonTapped so we save the date they selected, and not the current date
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text else {
            return
        }
        guard let type = employeeType else {
            return
        }
        
        let employee = Employee(name: name, dateOfBirth: dobDatePicker.date, employeeType: type)
        delegate?.employeeDetailTableViewController(self, didSave: employee)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        employee = nil
    }

    @IBAction func nameTextFieldDidChange(_ sender: UITextField) {
        updateSaveButtonState()
    }
    @IBSegueAction func showEmployeeTypes(_ coder: NSCoder) -> EmployeeTypeTableViewController? {
        let vc = EmployeeTypeTableViewController(coder: coder)
        vc?.delegate = self
        return vc
    }
}
