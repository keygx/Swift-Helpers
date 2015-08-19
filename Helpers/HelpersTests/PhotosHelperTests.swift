//
//  PhotosHelperTests.swift
//  HelpersTests
//
//  Created by keygx on 2015/08/05.
//  Copyright (c) 2015年 keygx. All rights reserved.
//

import UIKit
import XCTest
import Photos


class PhotosHelperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_A_SaveImageToPhotosLibraryFromUIImage() {
        
        let view = UIView(frame: CGRectMake(0, 0, 300, 300))
        view.backgroundColor = UIColor.redColor()
        let image = view.toImage()!
        
        let expectation = expectationWithDescription("Save Image from UIImage")
        
        PhotosHelper().saveImageToPhotosLibrary(image) { (success, error) in
            PAssert(success, ==, true)
            expectation.fulfill()
        }
                
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func test_B_SaveImageToPhotosLibraryFromURL() {
        let path = NSBundle(forClass: self.dynamicType).pathForResource("nadeusagi", ofType: "png")
        let url = NSURL(fileURLWithPath: path!)
        
        let metadata: NSDictionary = PhotosHelper().metadata(url)
        PAssert(metadata["ColorModel"] as! String, ==, "RGB")
        PAssert(metadata["PixelHeight"] as! NSNumber, ==, NSNumber(integer: 640))
        PAssert(metadata["PixelWidth"] as! NSNumber, ==, NSNumber(integer: 960))
        
        let expectation = expectationWithDescription("Save Image from URL")
        
        PhotosHelper().saveImageToPhotosLibrary(url) { (success, error) in
            PAssert(success, ==, true)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func test_C_SaveVideoToPhotosLibrary() {
        let path = NSBundle(forClass: self.dynamicType).pathForResource("nadeusagi", ofType: "mov")
        let url = NSURL(fileURLWithPath: path!)
        
        let expectation = expectationWithDescription("Save Video from URL")
        
        PhotosHelper().saveVideoToPhotosLibrary(url) { (success, error) in
            PAssert(success, ==, true)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func test_D_AssetsAndMetadata() {
        
        let allIDs = PhotosHelper().allAssetIDs()
        let assetList = PhotosHelper().assets(allIDs)
        
        // All Asset List
        PAssert(assetList.count, ==, allIDs.count)
        
        let expectation = expectationWithDescription("metadata")
        
        assetList[assetList.count-1].requestContentEditingInputWithOptions(nil) { (contentEditingInput, info) -> Void in
            
            if let contentEditingInput = contentEditingInput {
                let metadata: NSDictionary = PhotosHelper().metadata(contentEditingInput.fullSizeImageURL!)
                //println(meta)
                
                // Metadata
                PAssert(metadata["ColorModel"] as! String, ==, "RGB")
                PAssert(metadata["PixelHeight"] as! NSNumber, ==, NSNumber(integer: 600))
                PAssert(metadata["PixelWidth"] as! NSNumber, ==, NSNumber(integer: 600))
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func test_E_DeletaAssets() {
    
        let allIDs = PhotosHelper().allAssetIDs()
        let assetList = PhotosHelper().assets(allIDs)
        
        let startIndex = assetList.count-2-1
        let endIndex = assetList.count-1
        let deleteAssets: [PHAsset] = Array(assetList[startIndex...endIndex])
        
        let expectation = expectationWithDescription("delete")
        
        PhotosHelper().deletaAssets(deleteAssets) { (success, error) in
            PAssert(success, ==, true)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
    
}
