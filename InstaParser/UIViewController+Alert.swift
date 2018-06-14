//
//  UIViewController+Alert.swift
//  InstaParser
//
//  Created by Timur Mukhtasibov on 14.06.2018.
//  Copyright © 2018 EventrLLC. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlertWithErrorMessage(_ message: String? = nil, completion: @escaping (() -> Void)) {
        
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: completion)
    }
    
}
