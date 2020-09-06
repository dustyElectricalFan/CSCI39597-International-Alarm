//
//  addAlarmController.swift
//  internationalAlarm
//
//  Created by essdessder on 5/14/20.
//  Copyright © 2020 essdessder. All rights reserved.
//
// Created by Yusen Chen. essdessder is my mac name/ online handle

import UIKit

protocol addAlarmControllerDelegate: class{
    func createAlarm(_ controller: addAlarmController, date: Date, local: String, text: String, soundOn: Bool, repeatOn: Bool)
}

class addAlarmController: UITableViewController, searchViewControllerDelegate {
    
 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        clock.text = formatDate(date: Date())
        let span = singleUserDefaults.shared
        soundSwitch.isOn = span.getSoundBool()
        repeatSwitch.isOn = span.getrepeatBool()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    var locationstring = ""
    var datetimestring = ""
    var timestring = ""
    var datestring = ""
    
    var soundBool : Bool?
    var repeatBool: Bool?
   
    
    var foreignDate = Date()
    var pickeddate = Date()
    var alarmdate = Date()
    weak var delegate: addAlarmControllerDelegate?
    

    @IBOutlet weak var addLocation: UIButton!
    @IBOutlet weak var datepick: UIDatePicker!
    @IBOutlet weak var clock: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    @IBAction func pickDate(sender: UIDatePicker)
    {
        pickeddate = sender.date
        selectedDate()
    }
    @IBOutlet weak var soundSwitch: UISwitch!
    
    @IBAction func soundOnOff(_ sender: UISwitch) {
        soundBool = soundSwitch.isOn
    }
    @IBOutlet weak var repeatSwitch: UISwitch!
    
    @IBAction func repeatOnOff(_ sender: UISwitch) {
        repeatBool = repeatSwitch.isOn
    }
    
    
   

    
    func selectedDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if(foreignDate == Date())
        {
        var test = Date()
        var test2 = formatter.string(from: test)
        test = formatter.date(from: test2)!
        let datediff = test.getdaydiff(from: pickeddate)
        var modifieddate = Calendar.current.date(byAdding: .minute, value: datediff, to: Date())!
        test2 = formatter.string(from: modifieddate)
        modifieddate = formatter.date(from: test2)!
        alarmdate = modifieddate
      
        }
        else
        {
            var test = formatter.string(from: foreignDate)
            let test2 = formatter.date(from: test)!
            let datediff = test2.getdaydiff(from: pickeddate)
            var modifieddate = Calendar.current.date(byAdding: .minute, value: datediff, to: Date())!
            test = formatter.string(from: modifieddate)
            modifieddate = formatter.date(from: test)!
            alarmdate = modifieddate
        
            
        }
    }
    
    
    func formatDate(date: Date) -> String?
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }
    
    func turnIntoPickerFormat(datestring: String) -> Date?
    {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let date = formatter.date(from: datestring)
        return date
    }
    
    func turnIntoClockFormat(timestring: String) -> String?
    {
      
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let date = formatter.date(from: timestring)!
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    

    
    
    func didSelectLocation(_ controller: searchViewController, location: String) {
         navigationController?.popViewController(animated: true)
        locationstring = location
        addLocation.setTitle(location, for: .normal)
        getLocationTime(searchText: location)
        
     }
    
    func parsedatetime(inputString: String){
        let firstIn = inputString.range(of: "datetime")?.lowerBound
        var distance = inputString.distance(from: inputString.startIndex, to: firstIn!)
        let index = inputString.index(inputString.startIndex, offsetBy: distance + 11)
        let index2 = inputString.index(inputString.startIndex, offsetBy: distance + 26)
        let substring = inputString[index...index2]
        datetimestring = String(substring)
        let Tindex = datetimestring.range(of: "T")?.lowerBound
        distance = datetimestring.distance(from: datetimestring.startIndex, to: Tindex!)
        let Tindex2 = datetimestring.index(datetimestring.startIndex, offsetBy: distance + 1)
        let substring2 = datetimestring[Tindex2..<datetimestring.endIndex]
        let proxtimestring = String(substring2)
        timestring = turnIntoClockFormat(timestring: proxtimestring)!
        let substring3 = datetimestring[datetimestring.startIndex...Tindex!]
        datestring = String(substring3)
        let inputdate = turnIntoPickerFormat(datestring: datetimestring)
        foreignDate = inputdate!
        DispatchQueue.main.async {
            self.clock.text = self.timestring
            self.datepick.date = inputdate!
        }
        
        
        //To get amt of minutes between current location and selected timezone
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        var test = Date()
        let test2 = formatter.string(from: test)
        test = formatter.date(from: test2)!
       
        
    }
        

    func getLocationTime(searchText: String)
    {
        let urlString = String(format: "http://worldtimeapi.org/api/timezone/%@", searchText)
        let url = URL(string: urlString)
         let session = URLSession.shared
         let dataTask = session.dataTask(with: url!, completionHandler: { data,   response, error in if let error = error {print("Failure \(error.localizedDescription)")}
                 
             else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                 
                 if let data = data {
                    let dataString = String(data: data, encoding: .utf8)
                    self.parsedatetime(inputString: dataString!)
                 return
                 }
 
             }
                                                     
             else {print ("Success! \(response!)")}
             })
             dataTask.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        let controller = segue.destination as! searchViewController
        controller.delegate = self
        
    }
    
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{return 1}
        else if section == 1{return 3}
        else if section == 2{return 4}
        else {return 1}
        // #warning Incomplete implementation, return the number of rows
    }
    
    @IBAction func saveAlarm(){
        delegate?.createAlarm(self, date: alarmdate, local: locationstring, text: textField.text!, soundOn: soundBool ?? true, repeatOn: repeatBool ?? true)
    }
    
    @IBAction func cancelAlarm(){
        navigationController?.popViewController(animated: true)
    }

    
    


}
extension Date{
    
    func getdaydiff(from date: Date) -> Int
    {
        let min: Set<Calendar.Component> = [.minute]
        let difference = NSCalendar.current.dateComponents(min, from: self, to: date)
        return difference.minute ?? 0
        
    }
}
