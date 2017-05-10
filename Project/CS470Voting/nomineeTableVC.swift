//
//  nomineeTableVC.swift
//  CS470Voting
//
//  Created by Joe Mogannam on 4/18/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit


class nomineeTableVC: UITableViewController {
    
   
    // globals that are updated by the CategoreisTableVC
    var chosenCategory = String() // is populated in prepare function of catergoryTableVC
    //var colorWhichCell = -1
    var chosenNomineeId = -1
    
    
    // a category id is used to look up an array of nominee names
    // this is a dictionary whos values are arrays of strings
    var allNominees : Dictionary<Int, Array<String>> = [:]
    var allNomineesIds : Dictionary<Int, Array<Int>> = [:]

    // used to track whichnominees where voted for in a given category
    // is a dictionary who's key is the categoryID & value is an index 
    // to which column (aka which cell) was selected in the voting proccess
    var selectedNominesPerCategory : Dictionary<Int, Int> = [:]
    
    // these two functions are used in the catergoryTableVC to set our global variables
    // based on the category selected by the user
    func useCategory(_ categoryToUse: String){
        chosenCategory = categoryToUse
    }
    
    func useCategoryId (_ categoryId : Int){
        chosenCategoryId = categoryId;
        
    }
    
   
    // used to track which nominee the user voted for so we
    // can color that cell green
    var highlightedIndexPath : IndexPath?
    
    // a swift function that can execute code when the cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // get an array of all nominees fro the given category from a dictionary
        // of nominee arrays. CategoryID used to index dictionary and get array
        let nomineesIds = allNomineesIds[chosenCategoryId]
        
        // index the nominee array to find out which nominee was voted for
        // when user clicks a table cell
        chosenNomineeId = (nomineesIds?[indexPath.row ])!
       // print("chosenNomineeId: ", chosenNomineeId)
        
        //print("in button n id: ", chosenNomineeId )
        
        // a script that will be used to save the user votes
        let url =  "https://www.cs.sonoma.edu/~mogannam/chooseNominee.php"
        
        
        
        let postString = "account_id=\(logedInId)&category_id=\(chosenCategoryId)&nominee_id=\(chosenNomineeId)"
        print(postString)
        
        // currently the php script to inseert data is on my blue account
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        
        // bundle up data needed by script in POST method
        request.httpMethod = "POST"
   
        
        
        // actually bundeling up done
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        
        // handles highlighting the cell for the nominee the user voted for
        // if a cell is already highlighted check if we need to highlight a differnet
        // cell when the user changes their vote
        if self.highlightedIndexPath != indexPath  && self.highlightedIndexPath != nil {
            // user is changing their vote so unhighlight old cell & highlight new cell
            
            // get old cell that is highlighted so we can unhighlight it
            let unhighlightedCell = tableView.cellForRow(at: self.highlightedIndexPath!)
            unhighlightedCell?.backgroundColor = UIColor.white
            
            // highlight new cell
            self.highlightedIndexPath = indexPath
            let cell = tableView.cellForRow(at: indexPath)
            cell?.backgroundColor = UIColor.green
            
        }
        else {
            // user hasn't voted yet so we just need to highlight the cell
            // they voted for
            
            if(indexPath != nil){
            let cell = tableView.cellForRow(at: indexPath)
            
            cell?.backgroundColor = UIColor.green
            self.highlightedIndexPath = indexPath
            }
            
        }
        
        // cast the vote to the database
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
            
            
            var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            
            // attempt to cast vote
            do {
                
       
                
                var json = data//(try JSONSerialization.jsonObject(with: data!, //options: .mutableContainers) as? NSString)!
            

                //print(responseString)
                print("vote response message", responseString!)
                // the server includes  extra qoutation marks in the string of responseString
                // so for string comparison we need to include them when comparing
                
                var shouldColor = false // don't think this is used anymore
                
                if responseString == "\"success\"" {
                     // let user know the vote succeeded
                    shouldColor = true
                    DispatchQueue.main.async(execute: {
                        
                        gDisplayMSG( myMessage: "We saved your vote",  myTitle: "Thank you for voting", sendSelf : self as! nomineeTableVC )
                    })
                    
                }// let user know we changed their vote
                else if(responseString == "\"succesfully replace\""){
                    
                    shouldColor = true
                    
                    DispatchQueue.main.async(execute: {
                        gDisplayMSG( myMessage: "We changed your vote",  myTitle: "Thank you for voting", sendSelf : self as! nomineeTableVC)
                    })
                    
                }// an error occured let user know
                else {
                    DispatchQueue.main.async(execute: {
                        gDisplayMSG( myMessage: "Try voting again.",  myTitle: "Sorry, an Error ocured", sendSelf : self as! nomineeTableVC)
                    })
                }
                
                
                // don't think this is really used anymore b/c we copied the code from another similar function
                if let parseJson = json as? NSString  { // unwrap json as an NSArray
                    // parjson will contain an array of Json Dictionaries
                    // each dictionary represents 1 category stored on database
                    
                    // don't think this is used anymore
                    globalPushFunctionMsg =  String(parseJson)
                    
                    
                    
                }
                globalPushFunctionMsg =  "No string from php"
                
            }
            catch let caughtError as NSError {
                print("caught error: ", caughtError)
                return;
            }
            
        }
        
        
        
        task.resume()
        
        
        
        
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // pull nominess data from a MysqlView using a php file
        print("logged in user is : ", logedInId)
        
        // download all the data the user already voted for
        downloadVotedNominee(chosenCategoryId)
        // download all the nominees to populate the cells
        downloadNominees(chosenCategoryId)
        
    
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
        
        // get an array of nomines from our dictionary by using the category id 
        // chosen by the user as the key
        let someNominees = allNominees[chosenCategoryId]
        
        // make sure the array of nominees is not empty
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
            let nominees = allNominees[chosenCategoryId]
            //dictionary allNominees is a dictionary of arrays, the key is an string.
            //The value is an array of Strings
            
            //get array of all nominees for this tableview from a dictionary
            let nomineesIds = allNomineesIds[chosenCategoryId]
            
            
            // pass the nominee data to the current cell to be displayed
            theCell.useNominee((nominees?[indexPath.row ])!  , (nomineesIds?[indexPath.row ])!)
            
        // handles highlighting the cells if the user already voted and they restart the application
        // get the nominee id for the nominee in this cell
        var currentCellNomineeId = Int((nomineesIds?[indexPath.row])!)
        
        // see which nominee the user voted for for this category
        // aka get the nominee id for who they voted for
        var tempUsersVotedNominee = selectedNominesPerCategory[chosenCategoryId]
        
        // if the current nominee id of this cell matches the voted nomineeID
        // than highlight this cell green
        if currentCellNomineeId == tempUsersVotedNominee {
            theCell.backgroundColor = UIColor.green
            highlightedIndexPath = indexPath
            
        }
            
            
         cell = theCell
        
        }
        
        
        
        
        return cell
    }
    
    
    
    
    
    
    
    func downloadVotedNominee(_ catId : Int) {
        // handles pulling the data the nominee already for
        
        // currently the php script to inseert data is on my blue account
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.cs.sonoma.edu/~mogannam/userSelectionForCategoriesView.php")! as URL)
        
        // bundle up data needed by script in POST method
        request.httpMethod = "POST"
        
        // I dont belive the php script uses the category_id anymore since we changed the script
        // to always pull all data
        
        // account_id, category_id, nomine_id
        let postString = "account_id=\(logedInId)&category_id=\(catId)" //"a=\(email!)&b=\(password!)"
        
        // actually bundeling up done
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            // I believe this let structure is using the format of "completion handler"
            // my basic understanding is: data contains the response the script outputs back to swift,
            // response is used by swift to generate message based on what happens when communication with the script,
            // error will contain hopefully an error code/message that swift generates when the connection fails
            
            // used to insert new data in our dictionary,
            var  nomineeId = -1
            
            // check if the connection is even possible
            if error != nil {
                print("\n error: ", error ?? "no error explenation given")
                return;
            }
            
            // attempt to retrive data from database
            do {
                
                // converte the data response from php script to json array
                var json = (try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray)!
                
                //print(json)
                
                if let parseJson = json as? NSArray  { // unwrap json as an NSArray
                    // parjson will contain an array of Json Dictionaries
                    // each dictionary represents 1 category stored on database
                    
                    //print(parseJson)
                    
                    // loop through all records pulled 
                    // it should actually just be one nominee the user voted for
                    // we were being lazy and din't want to remove for loop from
                    // similar code we used
                    
                    
                   // for index in 0 ... parseJson.count - 1 {
                        
                        // cast the 1 nominee to a dictionary
                    print("DBG Before tempData = parseJson[0 ] as? NSDictionary ")
                    print("parseJson.count ",parseJson.count)
                    
                    if(parseJson.count >= 1){ // check if nominee casted a vote yet for this caregory if so you 
                                    // can't parse anything back from the php script
                    print("parseJson[0 ] is ", parseJson[0])
                    
                    if let tempData = parseJson[0 ] as? NSDictionary {
                        //print(tempData)
                        
                        print("tempData :",tempData)
                        print("pareJson[0]",  parseJson[0] )
                        print("dbg 1")
                       
                        
                        // get the id of the nominee voted for
                        var tempNomineeId = tempData["nominee_id"] as! String
                        nomineeId = Int(tempNomineeId)! as! Int
                        
                        print("dbg 2")
                        //print("hello nominee id", nomineeId)
                        //print("in the loop cat id : ", categoryId_ofNominee, "\n")
                        
                        // if an nominee  has no nominees  yet,insert nothing into our dictionary
                        print("dbg 3")
                        let keyExists = self.selectedNominesPerCategory[catId] != nil
                        if keyExists == false {
                            // nominee vote exists
                            
                            // insert a nomineeID into dictionary
                            // one category in the dictionary will have one id voted for
                            self.selectedNominesPerCategory[catId] = nomineeId
                            print("dbg 5, catID", catId)
                            
                        }
                        
                    }
                    }
                    
                    json = parseJson; // probaly not needed anymore
                    
                   
                    
                }
                
                // *** Important Code ****
                // this code is needed to update the table view controller
                // since this code runs on its own thread, there is potential of the
                // view controller loading before the data was even donwloaded resulting in an empty view controller
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func downloadNominees(_ catId : Int)  {
        // download all nominees so we can populate each cell with data
        
        // currently the php script to inseert data is on my blue account
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.cs.sonoma.edu/~mogannam/nomineesView.php")! as URL)
        
        // bundle up data needed by script in POST method
        request.httpMethod = "POST"
        
        // I dont belive the php script uses the category_id anymore since we changed the script
        // to always pull all data
        
        // account_id, category_id, nomine_id
        let postString = "account_id=\(logedInId)&category_id=\(catId)" //"a=\(email!)&b=\(password!)"
        
        // actually bundeling up done
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        // ++++ Waring start of threading ++++
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            // I believe this let structure is using the format of "completion handler"
            // my basic understanding is: data contains the response the script outputs back to swift,
            // response is used by swift to generate message based on what happens when communication with the script,
            // error will contain hopefully an error code/message that swift generates when the connection fails
            
            // used to insert new data in our dictionary,
            var  categoryId_ofNominee = -1
            var  nomineeId = -1
            
            // check if the connection is even possible
            if error != nil {
                print("\n error: ", error ?? "no error explenation given")
                return;
            }
            
            // attempt to retrive data from database
            do {
                
                // converte the data response from php script to json array
                var json = (try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray)!
                
                //print(json)
                
                if let parseJson = json as? NSArray  { // unwrap json as an NSArray
                    // parjson will contain an array of Json Dictionaries
                    // each dictionary represents 1 category stored on database
                    
                    //print(parseJson)
                    
                    // loop through all categories --> 1 category is a dictionary.
                    for index in 0 ... parseJson.count - 1 {
                        
                        // cast the 1 category to a dictionary
                        let tempData = parseJson[index ] as! NSDictionary
                        //print(tempData)
                        
                        // get the category name as a string
                        let nomineeName = tempData["nominee_name"] as! String
                        
                        // category id on mysql is stored as a string so you need to cast it to a
                        // string before we can cast it to an Int
                        var tempId = tempData["category_id"] as! String
                        categoryId_ofNominee = Int(tempId)!  as! Int
                        
                        print("category id of nominee ", categoryId_ofNominee)
                        print("tempData is ", tempData)
                        
                        var tempNomineeId = tempData["nominee_id"] as! String
                        nomineeId = Int(tempNomineeId)! as! Int
                        
                        //print("in the loop cat id : ", categoryId_ofNominee, "\n")
                        
                        // if a category  has no nominees  yet, make an array with one nominee
                        let keyExists = self.allNominees[categoryId_ofNominee] != nil
                        if keyExists == false {
                            
                            var tempArray = [String]()
                            tempArray.append(nomineeName)
                            
                            var temparray2 = [Int]()
                            temparray2.append(nomineeId)
                            
                            
                            self.allNominees[categoryId_ofNominee] = tempArray
                            self.allNomineesIds[categoryId_ofNominee] = temparray2
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
                            
                            var tempArray2 = [Int]()
                            tempArray2 = self.allNomineesIds[categoryId_ofNominee]!
                            tempArray2.append(nomineeId)
                            
                            self.allNomineesIds[categoryId_ofNominee]? = tempArray2
                        }
                        
                    }
                    
                    json = parseJson;
                    
                    /*print("++ ")
                    print(self.allNominees[categoryId_ofNominee] ?? "Nothing found \n")
                    print("++ END ++")*/
                    print("server done")
                    
                }
                
                // *** Important Code ****
                // this code is needed to update the table view controller
                // since this code runs on its own thread, there is potential of the
                // view controller loading before the data was even donwloaded resulting in an empty view controller
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
