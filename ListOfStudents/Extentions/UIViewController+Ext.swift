//
//  UIViewController+Ext.swift
//  ListOfStudents
//
//  Created by Антон on 01.11.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlertOnMainTread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
            let action = UIAlertAction(title: buttonTitle, style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
    
}
