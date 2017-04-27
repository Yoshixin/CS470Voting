//
//  categoriesTableVC.swift
//  CS470Voting
//
//  Created by mogannam on 4/17/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class categoriesTableVC: UITableViewController {
    
    //  a variable to hold original json data from script in case its needed in future
    var json = NSArray()
    
    
    var categories = [String]() //["Best Pic", "Best Artist"]
    
    
    override func viewDidLoad() {
        
        downloadCategories()
        super.viewDidLoad()
        
        
        
        
        
        
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
        
        print("in tableview ")
        
        if  categories.count > 0{
            return categories.count
            
        }
        
        return 0
    }
    
    // TODO :
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let allCategories = categories
        
        if let theCell = cell as? categoriesTableViewCell,
            let category = allCategories[indexPath.row] as? String {
            
            
            
            theCell.useCategory(category)
        }
        
        return cell
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // handles the transition from ArtistTableViewController to AlbumTableViewController
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //print("in ArtistsViewController, prepare()")
        
        
        if segue.identifier == "categoryToNominee" {
            
            
            // get the current cell
            let cell = sender as! categoriesTableViewCell
            
            // set up the transition from the current cell to the next tableviewcontroller
            if let indexPath = tableView.indexPath(for: cell) {
                
                // create a new nomineeTableViewController to transition to
                let nTableVC = segue.destination as! nomineeTableVC
                
                // pass the current category to the next tableViewController, so we have access to the
                // category
                // The category name is used to look up all nominees in a category
                
                var aCategory = categories[indexPath.row]
                var tempa = nTableVC.useCategory(aCategory)
                
                //tempa?.printArtist()
            }
            
        }
        
        
    }
    
    
    func downloadCategories()  {
        
        // currently the php script to inseert data is on my blue account
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.cs.sonoma.edu/~mogannam/categoriesView.php")! as URL)
        
        
        // bundle up data needed by script in POST method
        request.httpMethod = "POST"
        //we don't need to send any parameters for this php script, so leave post string empty
        let postString = "" //"a=\(email!)&b=\(password!)"
        
        // actually bundeling up done
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        
        
        // ++++ Waring start of threading ++++
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            // I believe this let structure is using the format of "completion handler"
            // my basic understanding is: data contains the response the script outputs back to swift,
            // response is used by swift to generate message based on what happens when communication with the script,
            // error will contain hopefully an error code/message that swift generates when the connection fails
            
            
            
            
            // check if the connection is even possible
            if error != nil {
                print("\n error: ", error ?? "no error explenation given")
                return;
            }
            
            
            
            
            
            // attempt to retrive data from database
            do {
                
                // converte the data response from php script to json array
                self.json = (try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray)!
                
                
                
                if let parseJson = self.json as? NSArray  { // unwrap json as an NSArray
                    // parjson will contain an array of Json Dictionaries
                    // each dictionary represents 1 category stored on fatabase
                    
                    // loop through all categories.
                    for index in 0 ... parseJson.count - 1 {
                        
                        var tempData = parseJson[index] as! NSDictionary
                        
                        
                        // get the category name as a string
                        var categoryName = tempData["category_name"] as! String
                        self.categories.append( categoryName)
                        
                        
                        
                    }
                    
                    self.json = parseJson;
                    
                    
                    
                    
                    
                    print(self.categories)
                    print("server done")
                    
                    
                }
                
                
                // *** Important Code ****
                // this code is needed to update the table view controller
                // since this code runs on its own thread, there is potential of the
                // view controller loading before the data was even donloaded resulting in an empty view controller
                // So at the end of the download we need the view controller to update itself
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                // *** ***** ********
                
                
            }
            catch let caughtError as NSError {
                print("caught error: ", caughtError)
                return;
            }
            
        }
        
        task.resume()
        
        
        
        
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
    
    
    
}
