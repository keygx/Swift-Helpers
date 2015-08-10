//
//  ViewController.swift
//  Helpers
//
//  Created by keygx on 2015/07/31.
//  Copyright (c) 2015年 keygx. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initialize() {
        
        PhotosHelper().autorizedPhotoStatus() { status in
            println(status.hashValue)
            switch status {
            case .NotDetermined:
                fallthrough
            case .Denied:
                PHPhotoLibrary.requestAuthorization() { status in
                    //
                }
            default:
                println("")
            }
        }
        
        PhotosHelper().autorizedCameraStatus() { status in
            println(status.hashValue)
        }
    }
}
