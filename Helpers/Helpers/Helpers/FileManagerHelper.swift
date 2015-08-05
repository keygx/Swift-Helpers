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
        let doc = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        return doc.stringByAppendingPathComponent(path)
    }
    
    /**
        Path: //tmp/..
    */
    func tmpDirectory(path: String = "") -> String {
        let tmp = NSTemporaryDirectory()
        return tmp.stringByAppendingPathComponent(path)
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
        
        if existsAtPath(path) {
            
            let list = manager.contentsOfDirectoryAtPath(path, error: nil)
            
            if let list = list {
                var pathList: [String] = []
                var i = 0
                for fileName in list {
                    let name: String = fileName as! String
                    ++i
                    pathList.append(path.stringByAppendingPathComponent(name))
                }
                
                if i == list.count {
                    return pathList
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    /**
        File Info
    */
    func fileInfo(path: String) -> [NSObject : AnyObject]? {
        return manager.attributesOfItemAtPath(path, error: nil)
    }
    
    /**
        Make Directory
    */
    func makeDir(path: String) -> Bool {
        
        if !existsAtPath(path) {
            
            let success = manager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: nil)
            
            if success {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    /**
        Save Binary File
    */
    func writeFile(path: String, data: NSData) -> Bool {
        
        let success = data.writeToFile(path, atomically: true)
        
        if success {
            return true
        } else {
            return false
        }
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
        
        let url = NSURL.fileURLWithPath(path)
        
        if let url = url {
            
            let success = url.setResourceValue(NSNumber(bool: true), forKey: NSURLIsExcludedFromBackupKey, error: nil)

            if success {
                println("Set Excluding \(url.lastPathComponent) From Backup")
            } else {
                println("Error Excluding \(url.lastPathComponent) From Backup")
            }
            return success
            
        } else {
            return false
        }
    }
    
    /**
        Remove at Path
    */
    func remove(path: String) -> Bool {
        
        if existsAtPath(path) {
            
            let success = manager.removeItemAtPath(path, error: nil)
            return success
            
        } else {
            return false
        }
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
        
        if let list = list {
            var pathList: [String] = []

            for filePath in list {
                if elapsedFileModificationDate(filePath, elapsedTime: elapsedTime) {
                    let success = remove(filePath)
                    if success {
                        pathList.append(filePath)
                    }
                }
            }
            return pathList
            
        } else {
            return nil
        }
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
        
        if existsAtPath(path) {
            
            let fileAttribures: NSDictionary = manager.attributesOfItemAtPath(path, error: nil)!
            
            let diff = NSDate(timeIntervalSinceNow: 0.0).timeIntervalSinceDate(fileAttribures.fileModificationDate()!)
            
            if elapsedTime < diff {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }

}
