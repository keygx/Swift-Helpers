//
//  DateHelper.swift
//  Helpers
//
//  Created by keygx on 2015/08/01.
//  Copyright (c) 2015年 keygx. All rights reserved.
//

import Foundation

class DateHelper {

    /**
        String -> NSDate
    */
    func dateFromString(
        dateString: String,
        dateFormat: String = "yyyy/MM/dd HH:mm:ss",
        localeIdentifier: String = NSLocale.currentLocale().localeIdentifier) -> NSDate? {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: localeIdentifier)
            dateFormatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            dateFormatter.dateFormat = dateFormat
            
            return dateFormatter.dateFromString(dateString)
    }
    
    /**
        NSDate -> String
    */
    func stringFromDate(
        date: NSDate,
        dateFormat: String = "yyyy/MM/dd HH:mm:ss",
        localeIdentifier: String = NSLocale.currentLocale().localeIdentifier) -> String {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: localeIdentifier)
            dateFormatter.calendar = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)
            dateFormatter.dateFormat = dateFormat
            
            return dateFormatter.stringFromDate(date)
    }
    
    /**
        UnixTime -> NSDate
    */
    func dateFromUnixTime(unixTime: NSTimeInterval) -> NSDate? {
        return NSDate(timeIntervalSince1970: unixTime)
    }
    
    /**
        NSDate -> UnixTime
    */
    func unixTimeFromDate(date: NSDate) -> NSTimeInterval {
        return date.timeIntervalSince1970
    }
    
    /**
        date1 == date2
    */
    func isSameDate(#date1: NSDate, date2: NSDate) -> Bool {
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        if let cal = calendar {
            return cal.isDate(date1, inSameDayAsDate: date2)
        } else {
            return false
        }
    }
    
    /**
        date1 < date2
    */
    func isNewDate(#date1: NSDate, date2: NSDate) -> Bool {
    
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        if let cal = calendar {
            let res: NSComparisonResult = cal.compareDate(date1, toDate: date2, toUnitGranularity: NSCalendarUnit.CalendarUnitSecond)
            switch res {
            case .OrderedAscending:
                return true
            case .OrderedDescending:
                return false
            case .OrderedSame:
                return false
            }
        } else {
            return false
        }
    }
}
