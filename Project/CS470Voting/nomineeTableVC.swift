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
    var chosenCategory = String()
    var chosenId = Int()
    
    var allNominees : Dictionary<Int, Array<String>> = [:] //  [Int: [String]  ]()
    
    func useCategory(_ categoryToUse: String){
        chosenCategory = categoryToUse
    }
    
    func useCategoryId (_ categoryId : Int){
        chosenId = categoryId;
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadNominees(chosenId)
        //allNominees["Best Picture"] = ["Fugitive, The", "Rocky", "Inside out", "Mission Impossible"]
        //allNominees["Best Artist"] = ["Harrison Ford", "Sean Connery", "Daniel Draig", "Scarlett Johansson", "Sandra Bullock", "Emma Stone", "Julia //Roberts"]
        
        
        
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
        let someNominees = allNominees[chosenId]
        
        
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
            let nominees = allNominees[chosenId]
            //dictionary allNominees is a dictionary of arrays, the key is an string.
            //The value is an array of Strings
            
            
            
            
            // pass the nominee data to the current cell to be displayed
            theCell.useNominee((nominees?[indexPath.row ])!)
            
            cell = theCell
        }
        
        
        
        
        return cell
    }
    
    
    
    func downloadNominees(_ catId : Int)  {
        
        // currently the php script to inseert data is on my blue account
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.cs.sonoma.edu/~mogannam/nomineesView.php")! as URL)
        
        
        // bundle up data needed by script in POST method
        request.httpMethod = "POST"
        //we don't need to send any parameters for this php script, so leave post string empty
        let postString = "category_id=\(catId)" //"a=\(email!)&b=\(password!)"
        
        // actually bundeling up done
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        
        
        // ++++ Waring start of threading ++++
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            // I believe this let structure is using the format of "completion handler"
            // my basic understanding is: data contains the response the script outputs back to swift,
            // response is used by swift to generate message based on what happens when communication with the script,
            // error will contain hopefully an error code/message that swift generates when the connection fails
            
            var  categoryId_ofNominee = -1
            
            
            // check if the connection is even possible
            if error != nil {
                print("\n error: ", error ?? "no error explenation given")
                return;
            }
            
            
            
            print("before break ")
            
            // attempt to retrive data from database
            do {
                
                // converte the data response from php script to json array
                var json = (try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray)!
                
                //print(json)
                
                if let parseJson = json as? NSArray  { // unwrap json as an NSArray
                    // parjson will contain an array of Json Dictionaries
                    // each dictionary represents 1 category stored on fatabase
                    
                    //print(parseJson)
                    
                    
                    
                    
                    // loop through all categories.
                    for index in 0 ... parseJson.count - 1 {
                        
                        let tempData = parseJson[index ] as! NSDictionary
                        print(tempData)
                        
                       
                        
                        
                        // get the category name as a string
                        let nomineeName = tempData["nominee_name"] as! String
                        var tempId = tempData["category_id"] as! String
                        categoryId_ofNominee = Int(tempId)!  as! Int
                        
                        
                        
                        print("in the loop cat id : ", categoryId_ofNominee, "\n")
                        // if an categories  has no nominees  yet, make an array with one nominee
                        let keyExists = self.allNominees[categoryId_ofNominee] != nil
                        if keyExists == false {
                            
                            var tempArray = [String]()
                            tempArray.append(nomineeName)
                            
                            self.allNominees[categoryId_ofNominee] = tempArray
                        }
                        
                        // if a nominee already has category && the nominee is not a duplicate
                        // get an array of all nominees for a single category, from the current dictionary
                        // check if the current nominee is already in the array
                        if keyExists == true,(self.allNominees[categoryId_ofNominee]?.contains(nomineeName))! == false {
                            // if the nominee is not already in the array, add it
                            var tempArray = [String]()
                            tempArray = self.allNominees[categoryId_ofNominee]!
                            tempArray.append(nomineeName)
                            
                            self.allNominees[categoryId_ofNominee]? = tempArray//.append(nomineeName)
                        }
                        
                        
                        
                        //self.nominees.append( nomineeName)
                        
                        
                        
                    }
                    
                    json = parseJson;
                    
                    
                    
                    
                    print("++ ")
                    print(self.allNominees[categoryId_ofNominee] ?? "Nothing found \n")
                    print("++ END ++")
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

    
    
    
    
}
