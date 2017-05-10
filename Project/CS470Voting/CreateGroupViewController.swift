//
//  CreateGroupViewController.swift
//  CS470Voting
//
//  Created by student on 5/8/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {
    
    @IBOutlet weak var groupText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCreateButton(_ sender: UIButton) {
        print("Tapped the create button.")
        let myAlert = UIAlertController(title:"Group Created!", message: "You can find your new group on the list of groups",
                                        preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.default, handler: nil);
        
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated:true, completion: nil)
        //Script to create a group goes HERE
        
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
