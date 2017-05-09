//
//  GroupsWithButtonVC.swift
//  CS470Voting
//
//  Created by student on 5/3/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class GroupsWithButtonVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var createbutton: UIButton!
    
    //  a variable to hold original json data from script in case its needed in future
    var json = NSArray()
    
    //variables for handling search bar and search results
    let searchController = UISearchController(searchResultsController: nil)
    var filteredGroups = [String]()
    
    //variables for handling all groups
    var groups = [String]()
    var groupIds = [Int]()
    
    var dummyGroups = [String]() //dummy variable for testing, delete
    
    /* Functions for searching */
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredGroups = dummyGroups.filter {$0.lowercased().contains(searchText.lowercased()) }
        
        tableview.reloadData()
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
        
        return dummyGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        
        //let allGroups = groups
        let allGroups = dummyGroups
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
    
    
    
    override func viewDidLoad() {
        tableview.delegate = self
        tableview.dataSource = self
        
        //dummy data, delete once real groups are implemented
        dummyGroups = ["a","B","C","d", "aa", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab"]
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableview.tableHeaderView = searchController.searchBar
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAGroup" {
            // get the current cell
            let cell = sender as! GroupTableViewCell
     
            // set up the transition from the current cell to the next tableviewcontroller
            if let indexPath = tableview.indexPath(for: cell), let groupID = groupIds[indexPath.row] as? Int {
                // create a new GroupMembersViewController to transition to
                let gmTableVC = segue.destination as! GroupMembersViewController
            }
        }
    }*/
    
    
    

}
