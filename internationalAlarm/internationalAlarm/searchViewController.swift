//
//  searchViewController.swift
//  internationalAlarm
//
//  Created by essdessder on 5/15/20.
//  Copyright © 2020 essdessder. All rights reserved.
//
// Created by Yusen Chen. essdessder is my mac name/ online handle

import UIKit

protocol searchViewControllerDelegate: class{
    func didSelectLocation(_ controller: searchViewController, location: String)
    
}

class searchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        loadAllLocaltions()
        

        // Do any additional setup after loading the view.
    }
    
    
    var searchResults = [String]()
    var startArray = [String]()
    var hasSearched = false
    var returnString = ""
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: searchViewControllerDelegate?
    var location = ""
    

    func parsee(data: Data) -> String?
    {
        return String(data: data, encoding: .utf8)
  
    }

    
    func parseThroughJSONString(parsestring: String) -> [String]
    {
        var JArray = [String]()
        var found = false
        var firstInx = parsestring.startIndex
        for i in 0..<parsestring.count
        {
            var index = parsestring.index(parsestring.startIndex, offsetBy: i)
            
            if found && parsestring[index] == "\""
            {
                found = false
                index = parsestring.index(parsestring.startIndex, offsetBy: i - 1)
                let mySubstring = parsestring[firstInx...index]
                JArray.append(String(mySubstring))
                continue
                        
            }
            
            if parsestring[index] == "\""
            {found = true
            firstInx = parsestring.index(parsestring.startIndex, offsetBy: i + 1)
            }
           
        }
        return JArray
        
    }

   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension searchViewController: UISearchBarDelegate {func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if !searchBar.text!.isEmpty{
    searchBar.resignFirstResponder()
    hasSearched = true
    tableView.reloadData()
    searchResults = []
        
        let searchQuery = searchBar.text!
        var counter = 0
        for i in startArray
        {
            if startArray[counter].contains(searchQuery)
            {
                searchResults.append(i)
            }
            counter += 1
        }
        tableView.reloadData()
    
    }
    else
    {
        hasSearched = false
        tableView.reloadData()
    }
    }
 
}

extension searchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasSearched {return startArray.count}
        else if searchResults.count == 0 {return 1}
        else{return searchResults.count}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchResultCell"
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)}
        
        if !hasSearched {
            cell.textLabel!.text = startArray[indexPath.row]
        }
        else if  hasSearched && searchResults.count > 0 {
            cell.textLabel!.text = searchResults[indexPath.row]
        }
        else {
            cell.textLabel!.text = "(Nothing Found)"
       }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !hasSearched{
            location = startArray[indexPath.row]
            
            delegate?.didSelectLocation(self, location: location)
        }
        else if hasSearched && searchResults.count > 0 {
            location = searchResults[indexPath.row]
            
            delegate?.didSelectLocation(self, location: location)
            
        }
        else
        {
            location = ""
        }
        print(location)
        
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {if searchResults.count == 0 && startArray.count == 0 {return nil} else {return indexPath}}
    
    
    func loadAllLocaltions(){
    let url = URL(string: "http://worldtimeapi.org/api/timezone")
    let session = URLSession.shared
    let dataTask = session.dataTask(with: url!, completionHandler: { data,   response, error in if let error = error {print("Failure \(error.localizedDescription)")}
            
        else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            
            if let data = data {
                
                self.returnString = self.parsee(data: data) ?? ""
                self.startArray = self.parseThroughJSONString(parsestring: self.returnString)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            return
            }
        }
                                                
        else {print ("Success! \(response!)")}
        })
        dataTask.resume()
       
        
    }
}

