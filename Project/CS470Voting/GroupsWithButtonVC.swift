//
//  GroupsWithButtonVC.swift
//  CS470Voting
//
//  Created by student on 5/3/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class GroupsWithButtonVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var grouptableview: UITableView!
    @IBOutlet weak var createbutton: UIButton!
    
    //  a variable to hold original json data from script in case its needed in future
    var json = NSArray()
    
    //variables for handling search bar and search results
    let searchController = UISearchController(searchResultsController: nil)
    var filteredGroups = [String]()
    
    //variables for handling all groups
    var groups = [String]()
    var groupIds = [Int]()
    
    //var dummyGroups = [String]() //dummy variable for testing, delete
    // relpace this with groups[String] when done
    
    /*override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(_animated)
        
        self.grouptableview.reloadData()
    } */
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(transitionBack) )
        self.navigationItem.leftBarButtonItem = newBackButton
        
        var selectedGroup = -1
        
        grouptableview.delegate = self
        grouptableview.dataSource = self
        
        downloadGroups()
        
        //dummy data, delete once real groups are implemented
        //dummyGroups = ["a","B","C","d", "aa", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab"]
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        grouptableview.tableHeaderView = searchController.searchBar
        
        super.viewDidLoad()
        
        self.grouptableview.reloadData()
    }
    
    func transitionBack() {
        //self.performSegue(withIdentifier: "GroupsToHome", sender: self)
        let tempHomeController = self.storyboard?.instantiateViewController(withIdentifier: "Home")  as! HomeViewController
        
        tempHomeController.navigationItem.hidesBackButton = true
        // transition to ChatLogTableVC and display message thread for this user and you
        self.navigationController?.pushViewController(tempHomeController ,animated: true)

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAGroup" {
            let tempGroupController = self.storyboard?.instantiateViewController(withIdentifier: "GroupsTableVC")  as! GroupMembersViewController
            //tempGroupController.setgroupID(_newID: selectedGroup)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selectedGroup = indexPath.row
        
    }
    
    /* Functions for searching */
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredGroups = groups.filter {$0.lowercased().contains(searchText.lowercased()) }
        
        grouptableview.reloadData()
    }
    //end of search functions
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning using dummy values
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredGroups.count
        }
        
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        
        //let allGroups = groups
        let allGroups = groups
        var group = ""
        
        if let theCell = cell as? GroupTableViewCell {
            if searchController.isActive && searchController.searchBar.text != "" {
                group = (filteredGroups[indexPath.row] as? String)!
            }
            else {
                group = (allGroups[indexPath.row] as? String)!
            }
            theCell.useGroup(group)
        }
        
        return cell
    }
    //end of table view data sources
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadGroups()  {
        
        // currently the php script to inseert data is on my blue account
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.cs.sonoma.edu/~mogannam/groupsView.php")! as URL)
        
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
                        var groupName = tempData["group_name"] as! String
                        var groupId = tempData["group_id"] as! String
                        var tempId = Int(groupId)
                        self.groupIds.append( tempId!)
                        self.groups.append( groupName)
                        
                        
                        
                    }
                    
                    self.json = parseJson;
                    
                    
                    
                    
                    
                    print(self.groups)
                    print("server done")
                    
                    
                }
                
                
                // *** Important Code ****
                // this code is needed to update the table view controller
                // since this code runs on its own thread, there is potential of the
                // view controller loading before the data was even donloaded resulting in an empty view controller
                // So at the end of the download we need the view controller to update itself
                DispatchQueue.main.async(execute: {
                    self.grouptableview.reloadData()
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
