//
//  TodoListTableViewController.swift
//  vision_todo_list
//
//  Created by Gatien DIDRY on 14/11/2022.
//

import UIKit

class TodoListTableViewController: UITableViewController {

var elements: [String] = []
let cellId = "customCell"
    override func viewDidLoad() {

        tableView.register(CustomTodoListCell.self, forCellReuseIdentifier: cellId )

        view.backgroundColor = .systemBackground
        title = "Todo List"
        navigationController?.navigationBar.prefersLargeTitles = true

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return elements.count

    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellId, for: indexPath) as? CustomTodoListCell else {
            return UITableViewCell()
        }

        cell.textField.text = elements[indexPath.row]

        return cell

    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            self.elements.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 100

    }
}
