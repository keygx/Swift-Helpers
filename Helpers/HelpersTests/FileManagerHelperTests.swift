//
//  FileManagerHelperTests.swift
//  HelpersTests
//
//  Created by keygx on 2015/08/01.
//  Copyright (c) 2015年 keygx. All rights reserved.
//

import UIKit
import XCTest

class FileManagerHelperTests: XCTestCase {
    
    var fileManager: FileManagerHelper?
    var testPath: String = ""
    
    override func setUp() {
        super.setUp()
        
        fileManager = FileManagerHelper()
        
        testPath = fileManager!.documentDirectory(path: "/TEST")
        println(testPath)
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func test_A_DocumentDirectory() {
        
        //println(fileManager.documentDirectory())
        //println(fileManager.documentDirectory(path: "/APP_NAME/Cache/"))
        
        let pattern = "^/.+/.+/Library/Developer/CoreSimulator/Devices/.+/data/Containers/Data/Application/.+/.+"
        let match = fileManager?.documentDirectory().rangeOfString(pattern, options: .RegularExpressionSearch)
        
        PAssert(match?.isEmpty, ==, false)
    }
    
    func test_B_TmpDocument() {
        
        //println(fileManager.tmpDirectory())
        //println(fileManager.tmpDirectory(path: "/APP_NAME/Temp/"))
        
        let pattern = "^/.+/.+/Library/Developer/CoreSimulator/Devices/.+/data/Containers/Data/Application/.+/.+"
        let match = fileManager?.tmpDirectory(path: "/APP_NAME/Temp/").rangeOfString(pattern, options: .RegularExpressionSearch)
        
        PAssert(match?.isEmpty, ==, false)
    }
    
    func test_C_MakeDir() {
        
        let success1 = fileManager?.makeDir(testPath)
        
        PAssert(success1, ==, true)
        
        let success2 = fileManager?.makeDir(testPath)
        
        PAssert(success2, ==, false)
    }
    
    func test_D_ExcludedFromBackup() {
        
        let success = fileManager?.excludedFromBackup(testPath)
        
        PAssert(success, ==, true)
    }
    
    func test_E_ExistsAtPath() {
        
        let success = fileManager?.existsAtPath(testPath)
        
        PAssert(success, ==, true)
    }
    
    func test_F_FileInfo() {
        
        let info: [NSObject : AnyObject]? = fileManager?.fileInfo(testPath)
        //println(info)
        
        PAssert(info?.count, >, 0)
    }
    
    func test_G_FileNameList() {
        
        let view1 = UIView(frame: CGRectMake(0, 0, 100, 100))
        view1.backgroundColor = UIColor.redColor()
        let imageData1 = NSData(data: UIImagePNGRepresentation(view1.toImage()))
        let path1 = fileManager?.documentDirectory(path: "/TEST/img1.png")
        fileManager?.writeFile(path1!, data: imageData1)
        
        let view2 = UIView(frame: CGRectMake(0, 0, 100, 100))
        view2.backgroundColor = UIColor.blueColor()
        let imageData2 = NSData(data: UIImagePNGRepresentation(view2.toImage()))
        let path2 = fileManager?.documentDirectory(path: "/TEST/img2.png")
        fileManager?.writeFile(path2!, data: imageData2)
        
        let list: [String]? = fileManager?.fileNameList(testPath)
        
        PAssert(list?.count, ==, 2)
        
        if let name: String = list?[0] {
            let paths = name.componentsSeparatedByString("/")
            
            PAssert(paths.last, ==, "img1.png")
        }
        
        if let name: String = list?[1] {
            let paths = name.componentsSeparatedByString("/")
            
            PAssert(paths.last, ==, "img2.png")
        }
    }
    
    func test_H_RemoveAll() {
        
        let path1 = fileManager?.documentDirectory(path: "/TEST/img1.png")
        let imageData1 = fileManager?.readFile(path1!)
        
        PAssert(imageData1, !=, nil)
        
        let path2 = fileManager?.documentDirectory(path: "/TEST/img2.png")
        let imageData2 = fileManager?.readFile(path2!)
        
        PAssert(imageData2, !=, nil)
        
        let success = fileManager?.removeAll(testPath)
        
        PAssert(success!, ==, true)
    }
    
    func test_I_RemovePastTime() {
        
        let view3 = UIView(frame: CGRectMake(0, 0, 100, 100))
        view3.backgroundColor = UIColor.greenColor()
        let imageData3 = NSData(data: UIImagePNGRepresentation(view3.toImage()))
        let path3 = fileManager?.documentDirectory(path: "/TEST/img3.png")
        fileManager?.writeFile(path3!, data: imageData3)
        
        let list: [String]? = fileManager?.removePastTime(testPath, elapsedTime: 0)
        
        PAssert(list?.count, ==, 1)
    }
    
    func test_J_Remove() {
        
        let success1 = fileManager?.remove(testPath)
        
        PAssert(success1, ==, true)
        
        let success2 = fileManager?.remove(testPath)
        
        PAssert(success2, ==, false)
    }
}

