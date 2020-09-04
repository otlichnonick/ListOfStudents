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
        if nameTextField.text != "" && surnameTextField.text != "" && assessmentTextField.text != "" {
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
        } else {
            getAlert(with: "Все поля должны быть заполнены!")
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func getAlert(with text: String) {
        let alert = UIAlertController(title: "Некорректные данные", message: text , preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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
        guard let text = textField.text else { return false }
        let newLenght = text.count + string.count - range.length
        if textField.tag == 1 || textField.tag == 2 {
            if string.rangeOfCharacter(from: CharacterSet.letters) != nil {
                return newLenght >= 0
            } else if string.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil{
                getAlert(with: "Поля ИМЯ и ФАМИЛИЯ можно заполнить только буквами")
            }
        }
        if textField.tag == 3 {
            let charactersSet = CharacterSet(charactersIn: "12345")
            if string.rangeOfCharacter(from: charactersSet) != nil {
                return newLenght <= 1
            } else if string.rangeOfCharacter(from: charactersSet.inverted) != nil {
                getAlert(with: "Введите число от 1 до 5")
            }
        }
        return true
    }
    
    
}
