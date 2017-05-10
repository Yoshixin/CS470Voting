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
    
    // an array of strings to populate the table cells
    var categories = [String]()
    // array of ids to track which category the user selected
    var categoryIds = [Int]()
    
    
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
        
        // determine how many categorys exist aka how many cells to create
        if  categories.count > 0{
            return categories.count
            
        }
        
        return 0
    }
    
    // TODO :
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create our custom tableViewCells
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        // get a local copy of all the categories that exist
        let allCategories = categories
        
        // populate the catehory data in the cell
        if let theCell = cell as? categoriesTableViewCell,
            let category = allCategories[indexPath.row] as? String  {
            // get the category name
            
            theCell.useCategory(category)
           
        }
        
        return cell
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // handles the transition from ArtistTableViewController to AlbumTableViewController
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       
        
        
        if segue.identifier == "categoryToNominee" {
            
            
            // get the current cell
            let cell = sender as! categoriesTableViewCell
            
            // set up the transition from the current cell to the next tableviewcontroller
            if let indexPath = tableView.indexPath(for: cell), let categoryId = categoryIds[indexPath.row] as? Int {
                
                // create a new nomineeTableViewController to transition to
                let nTableVC = segue.destination as! nomineeTableVC
                
                // pass the current category to the next tableViewController, so we have access to the
                // category
                // The category name is used to look up all nominees in a category
                var aCategory = categories[indexPath.row]
                var tempa = nTableVC.useCategory(aCategory)
                 nTableVC.useCategoryId(categoryId)
                
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
                    // each dictionary represents 1 category stored on database
                    
                    // loop through all categories.
                    for index in 0 ... parseJson.count - 1 {
                        
                        var tempData = parseJson[index] as! NSDictionary
                        
                        
                        // get the category name as a string
                        var categoryName = tempData["category_name"] as! String
                        var categoryId = tempData["category_id"] as! String
                        var tempId = Int(categoryId)
                        self.categoryIds.append( tempId!)
                        self.categories.append( categoryName)
                        
                    }
                    
                    self.json = parseJson;
                    
                    print("in categoreisTableVc server done")
                    
                    
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
    
    
    
}
