//
//  StudentViewController.swift
//  ListOfStudents
//
//  Created by Антон on 02.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit
import RealmSwift

class StudentViewController: UIViewController, UITextFieldDelegate {
    
    var name: String?
    var surname: String?
    var assessment: String?
    var selectedStudent: Student?
    var titleAction: String?
    
    let realm = try! Realm()
    
    //MARK: - Create UI Elements
    
    @IBOutlet weak var updaneData: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var assessmentTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        surnameTextField.delegate = self
        assessmentTextField.delegate = self
        
        setupUIelements()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    //MARK: - Setup UI elements
    
    func setupUIelements() {
        saveButton.layer.cornerRadius = 15.0
        cancelButton.layer.cornerRadius = 15.0
        nameTextField.keyboardType = .default
        surnameTextField.keyboardType = .default
        assessmentTextField.keyboardType = .numberPad
        nameTextField.text = name
        surnameTextField.text = surname
        assessmentTextField.text = assessment
        updaneData.text = titleAction
    }
    
    //MARK: - Setup button
    
    @IBAction func saveButton(_ sender: UIButton) {
        do {
            try realm.write {
                let newStudent = Student()
                newStudent.name = nameTextField.text!
                newStudent.surname = surnameTextField.text!
                newStudent.assessment = assessmentTextField.text!
                if newStudent != selectedStudent {
                    realm.add(newStudent)
                    if selectedStudent != nil {
                        realm.delete(selectedStudent!)
                    }
                }
            }
        } catch {
            print("Error saving new student. \(error)")
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            surnameTextField.becomeFirstResponder()
        } else if textField.tag == 2 {
            assessmentTextField.becomeFirstResponder()
        } else if textField.tag == 3 {
            assessmentTextField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 3 {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 1
        } else {
            return true
        }
    }
    
}

extension UITextField {
    
    func validateNameAndSurname(field: UITextField) -> String? {
        guard let text = field.text else {
            return nil
        }
        let RegEx = "1234567890^[^\\d!@#£$%^&*<>()/\\\\~\\[\\]\\{\\}\\?\\_\\.\\'\\'\\,\\:\\;|\"+=-]+$"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let isValid = Test.evaluate(with: text)
        
        if (isValid) {
            return text
        }
        return nil
    }
    
    func validateAssessment(field: UITextField) -> String? {
        guard let text = field.text else {
            return nil
        }
        let RegEx = "67890"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let isValid = Test.evaluate(with: text)
        
        if (isValid) {
            return text
        }
        return nil
    }
}
