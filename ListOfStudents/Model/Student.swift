//
//  Student.swift
//  ListOfStudents
//
//  Created by Антон on 02.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation
import RealmSwift

class Student: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var surname: String = ""
    @objc dynamic var assessment: String = ""
}

