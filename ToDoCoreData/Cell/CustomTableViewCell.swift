//
//  CustomTableViewCell.swift
//  ToDoCoreData
//
//  Created by Paul James on 27.10.2021.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var readyButton: UIButton!
    
    //для активации кнопки
    weak var cellTaskDelegate: PressReadyTaskButtonProtocols?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupButton()

    }
    
    func setupButton() {
//        readyButton.setBackgroundImage(UIImage(systemName: "chevron.down.circle"), for: .normal)
        readyButton.tintColor = .black
    }
    @IBAction func readyButtonTapped(_ sender: Any) {
        guard let index = index else {return}
        cellTaskDelegate?.readyButtonTapped(indexPath: index)
    }
    
    func configure(model: ToDoList) {
        
        switch model.priority {
        case 1:
            label.text = "❗️\(model.title!)"
        default:
            label.text = model.title
        }

        if model.isCompleted {
            readyButton.setBackgroundImage(UIImage(systemName: "chevron.down.square.fill"), for: .normal)
        } else {
            readyButton.setBackgroundImage(UIImage(systemName: "chevron.down.square"), for: .normal)
        }
    }


}
