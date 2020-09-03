//
//  StudentViewController.swift
//  ListOfStudents
//
//  Created by Антон on 02.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit

class StudentViewController: UIViewController, UITextFieldDelegate {
    
    var name: String?
    var surname: String?
    var assessment: String?
    
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
    }
    
    //MARK: - Setup button
    
    @IBAction func saveButton(_ sender: UIButton) {
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        
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
        if textField.tag == 1 || textField.tag == 2 {
            return string.rangeOfCharacter(from: CharacterSet.letters) != nil
        } else if textField.tag == 3 {
            if textField.text!.count < 1 {
                return string.rangeOfCharacter(from: CharacterSet(charactersIn: "67890")) == nil
            }
        }
        return false
    }
    

    
}

