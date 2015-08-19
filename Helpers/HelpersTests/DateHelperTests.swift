//
//  DateHelperTests.swift
//  HelpersTests
//
//  Created by keygx on 2015/08/01.
//  Copyright (c) 2015年 keygx. All rights reserved.
//

import UIKit
import XCTest

class DateHelperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDate() {
        
        let dateTime = "2015/08/01 00:00:00"
        
        let d = DateHelper()
        let date: NSDate? = d.dateFromString(dateTime)
        print(date)
        
        let dateStr: String = d.stringFromDate(date!)
        print(dateStr)
        
        PAssert(dateTime, ==, dateStr)
    }
    
    func testUnixTime() {
        let d = DateHelper()
        
        let date1 = d.dateFromUnixTime(1438587664.71403)
        print(date1)
        
        let date2 = d.unixTimeFromDate(date1!)
        print(date2)
        
        PAssert(1438587664.71403, ==, date2)
    }
    
    func testIsSameDate() {
        let d = DateHelper()
        
        let date1 = NSDate()
        let date2 = date1
        
        PAssert(d.isSameDate(date1: date1, date2: date2), ==, true)
    }
    
    func testIsNewDate() {
        let d = DateHelper()
        
        let date1: NSDate? = d.dateFromString("2015/08/01 00:00:00")
        let date2 = NSDate()
                
        PAssert(d.isNewDate(date1: date1!, date2: date2), ==, true)
    }
    
}
