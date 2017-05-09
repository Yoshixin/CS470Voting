//
//  ProfileViewController.swift
//  CS470Voting
//
//  Created by student on 5/8/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func UsernameEditingDidEnd(_ sender: Any) {
        //if (username.text != "" && username.text != "actual username")
            //change the username
        print("username edit ended")
    }
    
    @IBAction func EmailEditingDidEnd(_ sender: Any) {
        //if (email.text != "" && email.text != "actual email")
            //change the email
        print("email edit ended")
    }
    
    @IBAction func passwordEditingDidEnd(_ sender: Any) {
        //if (password.text != "" && password.text != "actual password")
            //change the password
        print("password edit ended")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        username.text = "User" //make this show the actual username
        email.text = "email@dummy" //make this show the actual email
        password.text = "password1" //make this show the actual password
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
