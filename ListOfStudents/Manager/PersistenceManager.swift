//
//  PersistenceManager.swift
//  ListOfStudents
//
//  Created by Антон on 01.11.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation
import RealmSwift

class PersistenceManager {
    
    var students: Results<Student>?
    
    func loadList() {
        let realm = try! Realm()
        students = realm.objects(Student.self).sorted(byKeyPath: "name")
    }
    
    func deleteItem(student: Student) {
        let realm = try! Realm()
            try! realm.write() {
                realm.delete(student)
        }
    }
    
    func updateData(of student: Student) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(student, update: .all)
        }
    }
    
    func addNew(_ student: Student) {
        let realm = try! Realm()
        try! realm.write() {
            realm.create(Student.self, value: ["name": student.name, "surname": student.surname, "assessment": student.assessment, "studentID": student.studentID], update: .all)
        }
    }
    
}

