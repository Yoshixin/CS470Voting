//
//  nomineeTableVC.swift
//  CS470Voting
//
//  Created by Joe Mogannam on 4/18/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class nomineeTableVC: UITableViewController {
    
    // a category name is used to look up an array of nominee names
    // this is a dictionary whos values are arrays of strings
    var chosenCategory = "NONE"
    
    var allNominees =  [String: [String]]()
    
    func useCategory(_ categoryToUse: String){
        chosenCategory = categoryToUse
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allNominees["Best Picture"] = ["Fugitive, The", "Rocky", "Inside out", "Mission Impossible"]
        allNominees["Best Artist"] = ["Harrison Ford", "Sean Connery", "Daniel Draig", "Scarlett Johansson", "Sandra Bullock", "Emma Stone", "Julia Roberts"]
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var someNominees = allNominees[chosenCategory]
        
        
        if someNominees != nil{ // make sure the category exists in our dictionary of categories
            if (someNominees?.count)! > 0 { // get the number of nominees in this one category
                return (someNominees?.count)!
                
            }
        }
        
        
        
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // handles the creation of a generic table view cell & casting it to an nomineTableViewCell,
        // and than populating it with data
        
        // create a generic reusable tableViewCell
        var cell = tableView.dequeueReusableCell(withIdentifier: "nomineeCell", for: indexPath)
        
        
        
        
        
        // cast the genric cell to a nomineeTableViewCell so we cal populat the cell
        // with data
        if let theCell = cell as? nomineeTableViewCell {
            
            // get all nominees for a Category from allNominees
            let nominees = allNominees[chosenCategory]
            //dictionary allNominees is a dictionary of arrays, the key is an string.
            //The value is an array of Strings
            
            
            
            
            // pass the nominee data to the current cell to be displayed
            theCell.useNominee((nominees?[indexPath.row ])!)
            
            cell = theCell
        }
        
        
        
        
        return cell
    }
    
    
    
    
    
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}