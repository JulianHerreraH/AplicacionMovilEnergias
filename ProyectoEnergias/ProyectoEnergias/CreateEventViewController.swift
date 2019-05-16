//
//  CreateEventViewController.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 5/4/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit
import EventKit
@objc protocol hasAddedReminderDelegate {
    func addedReminder(addedReminder: Bool)
}
class CreateEventViewController: UIViewController {

    @IBOutlet weak var addReminderBtn: UIButton!
    weak var delegate: hasAddedReminderDelegate?

    @IBOutlet weak var dateOicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addReminderClicked(_ sender: Any) {
        
        createReminderEvent(Date: self.dateOicker.date)
        showSpinner(onView: view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change
            self.dismiss(animated: true, completion: nil)
            self.delegate?.addedReminder(addedReminder: true)
        }

        

    }
    
    func createReminderEvent(Date date:Date){
        let eventStore:EKEventStore = EKEventStore()
        eventStore.requestAccess(to:  .event, completion:  {
            (granted,error) in
            if(granted && error == nil ){
                print("granted \(granted)")
                let event = EKEvent(eventStore: eventStore)
                event.title = "Recordatorio de límite de pago para mi recibo de luz"
                event.startDate = date
                event.endDate = date
                event.notes = "Creado por Ecobook"
                var alarm = EKAlarm()
                alarm.absoluteDate = date
                event.addAlarm(alarm)
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                }catch let error as NSError{
                    print("Error \(error)")
                }
            }
            else{
                print("Error \(error)")

            }
        })
        
        let reminderStore:EKEventStore = EKEventStore()
        reminderStore.requestAccess(to: .reminder, completion: {
            (granted,error) in
            if(granted && error == nil ){
                print("granted \(granted)")
                let reminder = EKReminder(eventStore: reminderStore)
                reminder.title = "Recordatorio de límite de pago para mi recibo de luz"
                reminder.notes = "Creado por Ecobook"
                reminder.calendar = reminderStore.defaultCalendarForNewReminders()
                var alarm = EKAlarm()
                alarm.absoluteDate = date
                reminder.addAlarm(alarm)
                do {
                    try reminderStore.save(reminder, commit: true)
                    print("REMINDER ENTERED SAVE")
                    
                }catch let error as NSError{
                    print("Error \(error)")
                }
            }
            else{
                print("Error \(error)")
                
            }
            
        })
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
