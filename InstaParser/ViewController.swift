//
//  ViewController.swift
//  InstaParser
//
//  Created by Timur Mukhtasibov on 10.05.2018.
//  Copyright © 2018 EventrLLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
    var accountName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func goButtonTapped() {
        textField.resignFirstResponder()
        imgView.image = nil
        IGAvaParser.parseInstaAvatarFor(accountName: accountName) { result, error in
            if let result = result {
                self.process(result)
            } else {
                self.showAlertWithErrorMessage(error ?? "unknown error", completion: {} )
                print("ERROR: \(error ?? "unknown error")")
            }
        }
    }
    
    private func process(_ result: String) {
        print("AVATAR: \(result)")
        if let url = URL(string: result) {
            do {
                let imageData = try Data(contentsOf: url)
                self.imgView.image = UIImage(data: imageData)
            } catch let error {
                print("ERROR: \(error.localizedDescription)")
                showAlertWithErrorMessage(error.localizedDescription, completion: {} )
            }
        }
    }
    
    @objc func tap() {
        textField.resignFirstResponder()
    }
    
    @objc func textFieldDidChange(notification: NSNotification) {
        if let textField = notification.object as? UITextField {
            accountName = textField.text ?? ""
        }
        goButton.isEnabled = !accountName.isEmpty
    }
    
}










