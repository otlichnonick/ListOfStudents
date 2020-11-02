//
//  ListViewController.swift
//  ListOfStudents
//
//  Created by Антон on 02.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UITableViewController {
    
    let persistenceManager = PersistenceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        persistenceManager.loadList()
        title = K.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        persistenceManager.loadList()
        tableView.reloadData()
    }
    
    func configureTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: K.cellName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        tableView.separatorColor = .label
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persistenceManager.students?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! StudentCell
        if let array = persistenceManager.students {
            let student = array[indexPath.row]
            cell.setupCell(with: student)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let student = persistenceManager.students?[indexPath.row] else { return }
            persistenceManager.deleteItem(student: student)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: K.storyboardName, bundle: nil)
        let studentVC = storyboard.instantiateViewController(withIdentifier: K.studentInfoVC) as! StudentViewController
        if let student = persistenceManager.students?[indexPath.row] {
            studentVC.configureVC(with: student, and: .updateItem)
            navigationController?.pushViewController(studentVC, animated: true)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.segueToNewItem, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueToNewItem {
            let destinationVC = segue.destination as! StudentViewController
            destinationVC.configureVC(with: nil, and: .createItem)
        }
    }
}
