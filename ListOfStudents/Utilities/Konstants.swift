//
//  Konstants.swift
//  ListOfStudents
//
//  Created by Антон on 13.10.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation

struct K {
    static let cellName         = "CustomCell"
    static let cellIdentifier   = "CustomCell"
    static let storyboardName   = "Main"
    static let studentInfoVC    = "StudentViewController"
    static let segueToNewItem   = "createNewStudent"
    static let title            = "Список студентов"
}

enum TypeAction: String {
    case createItem = "Добавить нового студента"
    case updateItem = "Обновить данные"
}

enum ErrorMessage {
    static let incorrectNameOrSurname   = "Поля ИМЯ и ФАМИЛИЯ можно заполнить только буквами"
    static let incorrectAssessment      = "Введите число от 1 до 5"
    static let unableAllData            = "Все поля должны быть заполнены!"
}

