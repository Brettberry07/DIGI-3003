//
//  ToDoCell.swift
//  ToDoList2
//
//  Created by Berry, Brett A. (Student) on 11/3/24.
//

import UIKit

protocol toDoCellDelegate: AnyObject {
    func checkMarkTapped(sender: ToDoCell)
}

class ToDoCell: UITableViewCell {
    
    //outlets
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    //variables
    weak var delegate: toDoCellDelegate?
    
    //overrides

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //functions
    
    
    //IBActions and SegueActions
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        delegate?.checkMarkTapped(sender: self)
    }
    
}
