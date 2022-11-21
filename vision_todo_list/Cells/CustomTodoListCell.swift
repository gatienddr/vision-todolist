//
//  CustomTableViewCell.swift
//  vision_todo_list
//
//  Created by Gatien DIDRY on 18/11/2022.
//

import UIKit

class CustomTodoListCell: UITableViewCell {

    let textField = UITextField()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Configure the view for the selected state
        contentView.addSubview(textField)

        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
