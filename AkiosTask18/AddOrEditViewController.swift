//
//  AddOrEditViewController.swift
//  AkiosTask18
//
//  Created by Nekokichi on 2020/09/13.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit

final class AddOrEditViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet private weak var completeInputButton: UIBarButtonItem!
    @IBOutlet private weak var inputNameTextField : UITextField!
    
    var segueIdentifier     : String!
    var selectedIndexPathRow: Int!
    var inputText           : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputNameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if segueIdentifier == "addSegue" {
            self.navigationItem.title = "項目追加"
            completeInputButton.title = "追加"
        }
        if segueIdentifier == "editSegue" {
            self.navigationItem.title = "項目編集"
            completeInputButton.title = "更新"
            inputNameTextField.text   = inputText
        }
    }
    
    override func resignFirstResponder() -> Bool {
        return true
    }
    
    func displayAlert() {
        let alertController = UIAlertController(title: "エラー", message: "1文字以上の文字を入力してください", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func completeInputButton(_ sender: UIButton) {
        if segueIdentifier == "addSegue" {
            // 文字が入力されてるかの確認
            if let text = inputNameTextField.text, !text.isEmpty {
                inputText  = inputNameTextField.text!
                performSegue(withIdentifier: "completeAdd", sender: nil)
            } else {
                displayAlert()
            }
        }
        if segueIdentifier == "editSegue" {
            if let text = inputNameTextField.text, !text.isEmpty {
                inputText  = inputNameTextField.text!
                performSegue(withIdentifier: "completeEdit", sender: nil)
            } else {
                displayAlert()
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
