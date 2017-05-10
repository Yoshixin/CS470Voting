//
//  GroupMembersViewController.swift
//  CS470Voting
//
//  Created by student on 5/8/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class GroupMembersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    //variables for handling all groups
    var members = [String]()
    var memberIds = [Int]()
    
    var dummyMems = [String]() //dummy variable for testing, delete
    // replace with members[string] later
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableview.delegate = self
        tableview.dataSource = self
        
        dummyMems = ["1","2","3","A Real Boy"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapJoinButton(_ sender: UIButton) {
        print("Tapped the join button.")
        //If joining the group
        let myAlert = UIAlertController(title:"Group Joined!", message: "You are now a member of this group",
                                        preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.default, handler: nil);
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion: nil)
        //Script to join group goes HERE
        
        //If leaving the group
        /*
         let myAlert = UIAlertController(title:"Group Left!", message: "You are no longer a member of this group",
         preferredStyle: UIAlertControllerStyle.alert)
         let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.default, handler: nil);
         myAlert.addAction(okAction)
         self.present(myAlert, animated:true, completion: nil)
         //Script to leave group goes HERE
         */
        
    }
    
    //Table view data sources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning using dummy values
        
        return dummyMems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // #warning using dummy values
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        
        //let allGroups = groups
        let allMembers = dummyMems
        var member = ""
        
        if let theCell = cell as? GroupMembersViewCell {
            member = (allMembers[indexPath.row] as? String)!
            theCell.useMember(member)
        }
        
        return cell
    }
    //end of table view data sources
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     }
     */
    
}
