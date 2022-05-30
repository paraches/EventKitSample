//
//  EventManager.swift
//  EventKitSample
//
//  Created by shinichi teshirogi on 2022/05/30.
//

import Foundation
import EventKit

class EventManager {
    let eventStore: EKEventStore
    var events: [EKEvent]?
    
    init() {
        self.eventStore = EKEventStore()
    }
    
    func numberOfEvents() -> Int {
        guard let events = events else {
            return 0
        }

        return events.count
    }
    
    func eventAt(row: Int) -> EKEvent? {
        guard let events = events else {
            return nil
        }

        return events[row]
    }
    
    func confirmAuthThen(completion: @escaping () -> Void) {
        if authorizationStatus() {
            print("already allowed")
            initEvents()
            completion()
            return
        }
        else {
            eventStore.requestAccess(to: .event, completion: { granted, error in
                if granted {
                    print("allowed now")
                    self.initEvents()
                    DispatchQueue.main.async {
                        completion()
                    }
                    return
                }
                else {
                    print("Not allowed")
                }
            })
        }
    }
    
    func authorizationStatus() -> Bool {
        let status = EKEventStore.authorizationStatus(for: .event)
        
        switch status {
        case .authorized:
            print("Authorized")
            return true
        case .notDetermined:
            print("Not determined")
            return false
        case .restricted:
            print("Restricted")
            return false
        case .denied:
            print("Denied")
            return false
        @unknown default:
            print("Unknown default")
            return false
        }
    }

    func initEvents() {
        let calendars = eventStore.calendars(for: .event)
        let predicate = eventStore.predicateForEvents(withStart: Calendar.current.date(byAdding: .month, value: -3, to: Date())!, end: Date(), calendars: calendars)
        events = eventStore.events(matching: predicate)
    }
}
