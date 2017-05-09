//
//  ViewController.swift
//  CS470Voting
//
//  Created by student on 4/3/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    //outlets for the profile options drop down
    @IBOutlet weak var dropDown: UIPickerView!
    
    @IBOutlet weak var textBox: UITextField!
    
    
    
    
    
    @IBAction func didTapSignoutTemp(_ sender: Any) {
        
        
        performSegue(withIdentifier: "signoutToLogin", sender: self)
        gSignOut(loggedInUser)
    }
    
    let profileOptions = ["Profile","Settings","Sign Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            // if user id is nil log us out b/c firebase can't work w/o user
            gSignOut()
            
        }
        
        
        
        
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Functions to support the profile options drop down
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return profileOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return profileOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.dropDown.isHidden = true
        //Handle changing to selected profile option view here
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.textBox {
            self.dropDown.isHidden = false
            textField.endEditing(true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.textBox {
            self.dropDown.isHidden = false
        }
        
       
    }
    
}
