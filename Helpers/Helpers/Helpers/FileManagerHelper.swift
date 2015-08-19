//
//  FileManager.swift
//  Helpers
//
//  Created by keygx on 2015/07/31.
//  Copyright (c) 2015年 keygx. All rights reserved.
//

import Foundation

class FileManagerHelper {
    
    let manager = NSFileManager()
    
    /**
        Path: //Documents/..
    */
    func documentDirectory(path: String = "") -> String {
        let doc: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        return doc.stringByAppendingPathComponent(path) as String
    }
    
    /**
        Path: //tmp/..
    */
    func tmpDirectory(path: String = "") -> String {
        let tmp: NSString = NSTemporaryDirectory()
        
        return tmp.stringByAppendingPathComponent(path) as String
    }
    
    /**
        Exists at Path
    */
    func existsAtPath(path: String) -> Bool {
        
        return manager.fileExistsAtPath(path)
    }
    
    /**
        //path/to/file1, file2, file3 .......  [path : Directory]
    */
    func fileNameList(path: String) -> [String]? {
        
        var list: [String]? = nil
        
        if !existsAtPath(path) {
            return list
        }
        
        do {
            list = try manager.contentsOfDirectoryAtPath(path)
            
            var pathList: [String] = []
            var i = 0
            for fileName in list! {
                let name: String = fileName 
                ++i
                let temp: NSString = path as NSString
                pathList.append(temp.stringByAppendingPathComponent(name) as String)
            }
            
            if i == list!.count {
                return pathList
            } else {
                return nil
            }
        
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
    
    /**
        File Info
    */
    func fileInfo(path: String) -> [NSObject : AnyObject]? {
        
        var info: [NSObject : AnyObject]? = nil
        
        do {
            info = try manager.attributesOfItemAtPath(path)
            
        } catch let error as NSError {
            print(error)
            info = nil
        }
        
        return info
    }
    
    /**
        Make Directory
    */
    func makeDir(path: String) -> Bool {
        
        var success: Bool = false
        
        if existsAtPath(path) {
            return success
        }
        
        do {
            try manager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
            success = true
        
        } catch let error as NSError {
            print(error)
            success = false
        }
        
        return success        
    }
    
    /**
        Save Binary File
    */
    func writeFile(path: String, data: NSData) -> Bool {
        let success = data.writeToFile(path, atomically: true)
        
        return  success
    }
    
    /**
        Read Binary File
    */
    func readFile(path: String) -> NSData? {
        
        if existsAtPath(path) {
            return NSData(contentsOfFile: path)
        }
        
        return nil
    }

    /**
        Excluding iCloud Backup
    */
    func excludedFromBackup(path: String) -> Bool {
        
        var success: Bool = false
        
        do {
            let url = NSURL.fileURLWithPath(path)
            try url.setResourceValue(NSNumber(bool: true), forKey: NSURLIsExcludedFromBackupKey)
            success = true
            
        } catch let error as NSError {
            print(error)
            success = false
        }
        
        return success
    }
    
    /**
        Remove at Path
    */
    func remove(path: String) -> Bool {
        
        var success: Bool = false
        
        if !existsAtPath(path) {
            return success
        }
        
        do {
            try manager.removeItemAtPath(path)
            success = true
        
        } catch let error as NSError {
            print(error)
            success = false
        }
        
        return success
    }
    
    /**
        Remove all files [path : Directory]
    */
    func removeAll(path: String) -> Bool {
        
        let list = fileNameList(path)
        
        if let list = list {
            var i = 0
            for filePath in list {
                remove(filePath)
                ++i
            }
            
            if i == list.count {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    /**
        Remove files at elapsed time settings  [path : Directory]
    */
    func removePastTime(path: String, elapsedTime: NSTimeInterval) -> [String]? {
        
        let list = fileNameList(path)
        
        guard let fileList = list else {
            return nil
        }
        
        var pathList: [String] = []
        
        for filePath in fileList {
            if elapsedFileModificationDate(filePath, elapsedTime: elapsedTime) {
                let success = remove(filePath)
                if success {
                    pathList.append(filePath)
                }
            }
        }
        
        return pathList
    }
    
    /**
        Check elapsed time
    
        elapsedTime:Sec. (ex.)
        1d:60x60x24       86400.00
        3d:60x60x24x3    259200.00
        1w:60x60x24x7    604800.00
        1m:60x60x24x30  2592000.00
    */
    func elapsedFileModificationDate(path: String, elapsedTime: NSTimeInterval) -> Bool {
        
        var match: Bool = false
        
        if !existsAtPath(path) {
            return match
        }
        
        do {
            let fileAttribures: NSDictionary = try manager.attributesOfItemAtPath(path)
            let diff = NSDate(timeIntervalSinceNow: 0.0).timeIntervalSinceDate(fileAttribures.fileModificationDate()!)
            
            if elapsedTime < diff {
                match = true
            } else {
                match = false
            }
        
        } catch let error as NSError {
            print(error)
            match = false
        }
        
        return match
    }

}
