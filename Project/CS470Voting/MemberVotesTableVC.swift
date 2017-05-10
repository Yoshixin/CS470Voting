//
//  MemberVotesTableVC.swift
//  CS470Voting
//
//  Created by student on 5/10/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class MemberVotesTableVC: UITableViewController {

    //  a variable to hold original json data from script in case its needed in future
    var json = NSArray()
    
    // an array of strings to hold information about categories
    var categories = [String]()
    // array of ids to track which categories the user made votes for
    var categoryIds = [Int]()
    
    //the ID of the member to view the votes of
    var accountID = -1
    
    // a category id is used to look up an array of nominee names
    // this is a dictionary whos values are arrays of strings
    var nominees = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadVotedNominees()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nominees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "memberVotesCell", for: indexPath)
        if let theCell = cell as? myVotesTableViewCell {
            theCell.setValues(_nominee: nominees[indexPath.row], _category: categories[indexPath.row])
            cell = theCell
        }
        return cell
    }
    
    func setAccountID(_newID: Int) {
        accountID = _newID
    }

    func downloadVotedNominees() {
        // handles pulling the data the nominee already for
        // currently the php script to inseert data is on my blue account
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.cs.sonoma.edu/~mogannam/myVotes.php")! as URL)
        // bundle up data needed by script in POST method
        request.httpMethod = "POST"
        // I dont belive the php script uses the category_id anymore since we changed the script
        // to always pull all data
        // account_id, category_id, nomine_id
        
        print("member to view, ", accountID)
        let postString = "account_id=\(accountID)"
        // actually bundling up done
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            // I believe this let structure is using the format of "completion handler"
            // my basic understanding is: data contains the response the script outputs back to swift,
            // response is used by swift to generate message based on what happens when communication with the script,
            // error will contain hopefully an error code/message that swift generates when the connection fails
            // used to insert new data in our dictionary,
            // check if the connection is even possible
            if error != nil {
                print("\n error: ", error ?? "no error explenation given")
                return;
            }
            // attempt to retrive data from database
            do {
                // convert the data response from php script to json array
                
                print("data size", data?.count)
                var json = (try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray)!
                if let parseJson = json as? NSArray  { // unwrap json as an NSArray
                    if(parseJson.count>0) {
                        for index in 0 ... parseJson.count - 1 {
                            // can't parse anything back from the php script
                            if let tempData = parseJson[index ] as? NSDictionary {
                                // get the data from the dictionary
                                if let categoryName = tempData["category_name"] as? String,
                                let nomineeName = tempData["nominee_name"] as? String {
                                    self.categories.append( categoryName)
                                    self.nominees.append( nomineeName)
                                }
                            }
                        }
                    }
                }
                // *** Important Code ****
                // this code is needed to update the table view controller
                // since this code runs on its own thread, there is potential of the
                // view controller loading before the data was even donwloaded resulting in an empty view controller
                // So at the end of the download we need the view controller to update itself
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
            catch let caughtError as NSError {
                print("caught error: ", caughtError)
                return;
            }
        }
        task.resume()
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
