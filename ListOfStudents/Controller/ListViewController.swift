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
    
    let realm = try! Realm()
    
    var students: Results<Student>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadList()
        
        title = "Список студентов"
        
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadList()
    }
    
    //MARK: - Data manipulation methods
    
    func loadList() {
        students = realm.objects(Student.self).sorted(byKeyPath: "name")
        
        tableView.reloadData()
    }
    
    func deleteItem(at indexPath: IndexPath) {
        if let item = students?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting an item. \(error)")
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return students?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! StudentCell
        
        if let student = students?[indexPath.row] {
            cell.setupCell(with: student)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteItem(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    
    
    //MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StudentViewController") as! StudentViewController
        if let student = students?[indexPath.row] {
            vc.name = student.name
            vc.surname = student.surname
            vc.assessment = student.assessment
            vc.selectedStudent = student
            vc.titleAction = "Обновить данные"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //MARK: - Add New Student
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "createNewStudent", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createNewStudent" {
            let destinationVC = segue.destination as! StudentViewController
            destinationVC.name = ""
            destinationVC.surname = ""
            destinationVC.assessment = ""
            destinationVC.titleAction = "Добавить нового студента"
        }
    }
}
