//
//  MainViewController.swift
//  internationalAlarm
//
//  Created by essdessder on 5/9/20.
//  Copyright © 2020 essdessder. All rights reserved.
//
// Created by Yusen Chen. essdessder is my mac name/ online handle

import UIKit
import UserNotifications
import CoreData

class MainViewController: UITableViewController, addAlarmControllerDelegate{
    
    
    func createAlarm(_ controller: addAlarmController, date: Date, local: String, text: String, soundOn: Bool, repeatOn: Bool) {
        navigationController?.popViewController(animated: true)
        selectedDate = date
        location = local
        note = text
        sound = soundOn
        repeating = repeatOn
        
        addAlarm()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let controller = segue.destination as! addAlarmController
        controller.delegate = self
    }
    
    

    var selectedDate = Date()
    var location = ""
    var note = ""
    var sound = true
    var repeating = false
    var alarms = [AlarmItem]()
    
 

    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationcenter = UNUserNotificationCenter.current()
        
        notificationcenter.requestAuthorization(options: [.alert, .sound], completionHandler: {granted, error in
            if !granted{
                DispatchQueue.main.async {
                    self.alertServicesDeniedAlert()
                    return
                }
            }
            
        })
            
        
        
        let fetchRequest: NSFetchRequest<AlarmItem> = AlarmItem.fetchRequest()
        do{ let alarms = try saveAlarm.context.fetch(fetchRequest)
            self.alarms = alarms
            self.tableView.reloadData()
        }
        catch{
            print(error.localizedDescription)
            
        }
    }
    
    func alertServicesDeniedAlert(){
        let alert = UIAlertController(
            title: "User notifications denied",
            message: "Please enable user notifications for this app in the settings for this app to function. You can still add alarms, but they will not go off.", preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    func scheduleNotification(date: Date, ustring: String, soundOn: Bool, repeatOn: Bool){
        let notificationcenter = UNUserNotificationCenter.current()
        let alarm = UNMutableNotificationContent()
        alarm.title = note
        
        if location != ""
        {alarm.body = location}
        else
        {alarm.body = ustring}
        
        if(soundOn)
        {alarm.sound = .default}
        else{alarm.sound = .none}
        
        
        var datecomponents = DateComponents()
        let calendar = Calendar.current
        
        datecomponents.year = calendar.component(.year, from: date)
        datecomponents.month = calendar.component(.month, from: date)
        datecomponents.day = calendar.component(.day, from: date)
        datecomponents.hour = calendar.component(.hour, from: date)
        datecomponents.minute = calendar.component(.minute, from: date)
        
        if(!repeatOn)
        {
        let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponents, repeats: false)
        let request = UNNotificationRequest(identifier: ustring, content: alarm, trigger: trigger)
            
        notificationcenter.add(request)
        }
      
            
        else
        {
        let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponents, repeats: true)
       
        let request = UNNotificationRequest(identifier: ustring, content: alarm, trigger: trigger)
        
        notificationcenter.add(request)
        }
    }
   


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return alarms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as! alarmCell
        
        cell.timeLabel.text = alarms[indexPath.row].time?.description
        cell.locLabel.text = alarms[indexPath.row].location?.description
        cell.dateLabel.text = alarms[indexPath.row].date?.description
        cell.desLabel.text = alarms[indexPath.row].note?.description


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)}
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        let center = UNUserNotificationCenter.current()

        center.removeDeliveredNotifications(withIdentifiers: [self.alarms[indexPath.row].uustring])
        center.removePendingNotificationRequests(withIdentifiers: [self.alarms[indexPath.row].uustring])
        saveAlarm.context.delete(self.alarms[indexPath.row])
        alarms.remove(at: indexPath.row)
        saveAlarm.saveContext()
        self.tableView.reloadData()
        
    }
    
        func addAlarm() {
        
        let newalarm = AlarmItem(context: saveAlarm.context)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        newalarm.time = formatter.string(from: selectedDate)
        newalarm.location = location
        newalarm.note = note
        formatter.dateFormat = "yyyy-MM-dd"
        newalarm.date = formatter.string(from: selectedDate)
        newalarm.uustring = UUID().uuidString

        saveAlarm.saveContext()
        self.alarms.append(newalarm)
        self.tableView.reloadData()
        scheduleNotification(date: selectedDate, ustring: newalarm.uustring, soundOn: sound, repeatOn: repeating)
        
        
    }
        
        
    
}
