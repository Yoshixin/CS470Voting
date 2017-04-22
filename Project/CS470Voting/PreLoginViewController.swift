//
//  ViewController.swift
//  Login
//
//  Created by Joe Mogannam on 4/19/17.
//  Copyright © 2017 Joe Mogannam. All rights reserved.
//

import UIKit

class PreLoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // controls auto navigation between two views. In this case if the
        // user is loged in, they should automatically be transfered to home
        // If they are not Logeed in they should be transfered to Login/Register page
        
        
        // an example of how a cached variable can be stored
        var isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        // if you set isUserLoggedIn to true you can skip al login/register pages
        
        isUserLoggedIn = false
        
        
        
        if(!isUserLoggedIn){ // if user not logged in go to Login/Register
            self.performSegue(withIdentifier: "ToLoginView", sender: self)
        }
        else{ // user is loged in go to home
          self.performSegue(withIdentifier: "SkipLogin", sender: self)
        }
    }
    
}

