//
//  StudentViewController.swift
//  ListOfStudents
//
//  Created by Антон on 02.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit
import RealmSwift

class StudentViewController: UIViewController {
    
    var selectedStudent: Student!
    var titleText: String!
    var persistenceManager = PersistenceManager()
    
    let realm = try! Realm()
        
    @IBOutlet weak var updateData: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var assessmentTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIElements()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func configureUIElements() {
        nameTextField.delegate              = self
        surnameTextField.delegate           = self
        assessmentTextField.delegate        = self
            
        saveButton.layer.cornerRadius       = 15.0
        cancelButton.layer.cornerRadius     = 15.0
        nameTextField.keyboardType          = .default
        surnameTextField.keyboardType       = .default
        assessmentTextField.keyboardType    = .numberPad
        nameTextField.text                  = selectedStudent?.name
        surnameTextField.text               = selectedStudent?.surname
        assessmentTextField.text            = selectedStudent?.assessment
        updateData.text                     = titleText
    }
        
    func configureVC(with student: Student?, and action: TypeAction) {
        selectedStudent = student
        switch action {
        case .updateItem: titleText = TypeAction.updateItem.rawValue
        case .createItem: titleText = TypeAction.createItem.rawValue
        }
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        guard nameTextField.text != "" && surnameTextField.text != "" && assessmentTextField.text != "" else {
            presentAlertOnMainTread(title: "Некорректные данные", message: ErrorMessage.unableAllData, buttonTitle: "Ok")
            return
        }
        if let newStudent = selectedStudent {
            let student = Student(name: nameTextField.text!, surname: surnameTextField.text!, assessment: assessmentTextField.text!, studentID: newStudent.studentID)
            persistenceManager.updateData(of: student)
        } else {
            let student = Student(name: nameTextField.text!, surname: surnameTextField.text!, assessment: assessmentTextField.text!, studentID: UUID().uuidString)
            persistenceManager.addNew(student)
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension StudentViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1: surnameTextField.becomeFirstResponder()
        case 2: assessmentTextField.becomeFirstResponder()
        case 3: assessmentTextField.resignFirstResponder()
        default: break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newLenght = text.count + string.count - range.length
        switch textField.tag {
        case 1, 2:
            if string.rangeOfCharacter(from: CharacterSet.letters) != nil {
                return newLenght >= 0
            } else if string.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil {
                presentAlertOnMainTread(title: "Некорректные данные", message: ErrorMessage.incorrectNameOrSurname, buttonTitle: "Ok")
            }
        case 3:
            let charactersSet = CharacterSet(charactersIn: "12345")
            if string.rangeOfCharacter(from: charactersSet) != nil {
                return newLenght <= 1
            } else if string.rangeOfCharacter(from: charactersSet.inverted) != nil {
                presentAlertOnMainTread(title: "Некорректные данные", message: ErrorMessage.incorrectAssessment, buttonTitle: "Ok")
            }
        default: break
        }
        return true
    }
}

