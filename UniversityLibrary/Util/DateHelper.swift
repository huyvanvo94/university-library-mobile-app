//
//  DateHelper.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/17/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

class DateHelper{
    
    static func isTomorrow(dt: TimeInterval) -> Bool{
        return numberFromToday(dt: dt) == 1
    }
    
    static func numberFromToday(dt: TimeInterval) -> Int{
        let today = Date()
        let requestedDate = Date(timeIntervalSince1970: dt)
        
        let calendar = NSCalendar.current
        
        let fromDate = calendar.startOfDay(for: today)
        let toDate = calendar.startOfDay(for: requestedDate)
        
        let components = calendar.dateComponents([.day], from: fromDate, to: toDate)
        
        return components.day!
    }
    
    static func numberFromLocalToday(dt: TimeInterval) -> Int{
        let today = Date()
        let requestedDate = Date(timeIntervalSince1970: dt)
        
        let calendar = NSCalendar.current
        
        let fromDate = calendar.startOfDay(for: today)
        let toDate = calendar.startOfDay(for: requestedDate)
        var components = calendar.dateComponents([.day], from: fromDate, to: toDate)
        components.timeZone = TimeZone.current
        return components.day!
    }
    
    static func getLocalDate(dt: TimeInterval) -> String{
        return getLocalDate(dt: dt, timeZoneId: TimeZone.current.identifier)
    }
    
    static func getLocalDate(dt: TimeInterval, timeZoneId: String) -> String{
        let date = Date(timeIntervalSince1970: dt)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium//Set date style
        dateFormatter.timeZone = TimeZone(identifier: timeZoneId)
        return dateFormatter.string(from: date as Date)
    }
    
    
    static func createDate(year: Int, month: Int, day: Int) -> Date?{
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.timeZone = TimeZone(abbreviation: "UTC") // Universial
        
        let userCalendar = Calendar.current
        return userCalendar.date(from: dateComponents)
    }
    
    static func isToday(dt: TimeInterval) -> Bool{
        return numberFromLocalToday(dt: dt) == 0
    }
}

extension Date{
    var mock_thirdyDaysfromNow: Date{
        return Date().addingTimeInterval(10000)
    }
    
    // books will be due 30 days from today
    var thirtyDaysfromNow: Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: 30, to: self, options: [])!
    }
    
    // books can we reserve 3 days
    var threeDaysFromNow: Date{
         return (Calendar.current as NSCalendar).date(byAdding: .day, value: 3, to: self, options: [])!
    }
    
    var oneDayFromNow: Date{
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: 1, to: self, options: [])!
    }
}

