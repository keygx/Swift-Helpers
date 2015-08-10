//
//  PhotosHelper.swift
//  Helpers
//
//  Created by keygx on 2015/08/05.
//  Copyright (c) 2015年 keygx. All rights reserved.
//

import UIKit
import Photos

/*struct AssetInfo {
    var name: String?
    var url: NSURL?
    var creationDate: NSDate?
    var width: Int = 0
    var height: Int = 0
    var filelength: UInt64 = 0
    var uti: String = ""
    var orientation: Int32?
    var displaySizeImage: UIImage?
    var duration: NSTimeInterval?
}*/

class PhotosHelper {
    
    // All Asset IDs
    func allAssetIDs() -> [String] {
    
        var allIDs: [String] = [String]()
        
        // PHCollectionList
        let collectionLists: PHFetchResult = PHCollectionList.fetchCollectionListsWithType(.MomentList, subtype: .Any, options: nil)
        collectionLists.enumerateObjectsUsingBlock { (collectionList, idx, stop) -> Void in
            // PHAssetCollection
            let result: PHFetchResult = PHAssetCollection.fetchMomentsInMomentList(collectionList as! PHCollectionList, options: nil)
            result.enumerateObjectsUsingBlock { (assetCollection, idx, stop) -> Void in
                // PHAsset
                let assets: PHFetchResult = PHAsset.fetchAssetsInAssetCollection(assetCollection as! PHAssetCollection, options: nil)
                assets.enumerateObjectsUsingBlock { (asset, idx, stop) -> Void in
                    allIDs.append(asset.localIdentifier)
                }
            }
        }
    
        var assetIDs = allIDs.reduce([String](), combine: {
            var temp = $0
            let identifier = $1
            let count: Int = temp.filter({ $0 == identifier }).count
            if count == 0 { temp.append($1) }
            
            return temp
        })
        //println(assetIDs)
        
        return assetIDs
    }
    
    // All PHAseets
    func assets(localIdentifiers: [String]) -> [PHAsset] {
        
        var assetList: [PHAsset] = [PHAsset]()
        
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        
        let assets: PHFetchResult = PHAsset.fetchAssetsWithLocalIdentifiers(localIdentifiers, options: options)
    
        assets.enumerateObjectsWithOptions(NSEnumerationOptions.Concurrent) { (obj, idx, stop) -> Void in
            
            if let asset = obj as? PHAsset {
                assetList.append(asset)
            }
        }
        
        return assetList
    }
    
    
    /*func assets(localIdentifiers: [String]) {
        
        var assetInfoList: [AssetInfo] = [AssetInfo]()
        
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        
        let assets: PHFetchResult = PHAsset.fetchAssetsWithLocalIdentifiers(localIdentifiers, options: options)
    
        assets.enumerateObjectsWithOptions(NSEnumerationOptions.Concurrent) { (obj, idx, stop) -> Void in
            
            if let asset = obj as? PHAsset {
                
                if asset.mediaType == .Image {
                    // image
                    asset.requestContentEditingInputWithOptions(nil) { (contentEditingInput, info) -> Void in
                        
                        var assetInfo = AssetInfo()
                        assetInfo.name = ""
                        assetInfo.url = contentEditingInput.fullSizeImageURL
                        assetInfo.creationDate = contentEditingInput.creationDate
                        assetInfo.width = asset.pixelWidth
                        assetInfo.height = asset.pixelHeight
                        assetInfo.uti = contentEditingInput.uniformTypeIdentifier
                        assetInfo.orientation = contentEditingInput.fullSizeImageOrientation
                        assetInfo.displaySizeImage = contentEditingInput.displaySizeImage
                        if let path = assetInfo.url?.path {
                            if let attr: NSDictionary = NSFileManager.defaultManager().attributesOfItemAtPath(path, error: nil) {
                                assetInfo.filelength = attr.fileSize()
                            }
                        }
                        /*println("-----")
                        println("name : \(assetInfo.name)")
                        println("url : \(assetInfo.url)")
                        println("creationDate : \(assetInfo.creationDate)")
                        println("filelength : \(assetInfo.filelength)")
                        println("uti : \(assetInfo.uti)")
                        println("orientation : \(assetInfo.orientation)")
                        println("displaySizeImage : \(assetInfo.displaySizeImage)")
                        println("duration : \(assetInfo.duration)")*/
                        assetInfoList.append(assetInfo)
                    }
                    
                } else {
                    // video
                    PHImageManager.defaultManager().requestAVAssetForVideo(asset, options: nil) { (avAsset, _, _) -> Void in
                        
                        var assetInfo = AssetInfo()
                        if let avurlAsset: AVURLAsset = avAsset as? AVURLAsset {
                            assetInfo.name = ""
                            assetInfo.url = avurlAsset.URL
                            assetInfo.creationDate = asset.creationDate
                            assetInfo.duration = asset.duration
                            if let path = assetInfo.url?.path {
                                if let attr: NSDictionary = NSFileManager.defaultManager().attributesOfItemAtPath(path, error: nil) {
                                    assetInfo.filelength = attr.fileSize()
                                }
                            }
                            /*println("-----")
                            println("name : \(assetInfo.name)")
                            println("url : \(assetInfo.url)")
                            println("creationDate : \(assetInfo.creationDate)")
                            println("filelength : \(assetInfo.filelength)")
                            println("uti : \(assetInfo.uti)")
                            println("orientation : \(assetInfo.orientation)")
                            println("displaySizeImage : \(assetInfo.displaySizeImage)")
                            println("duration : \(assetInfo.duration)")*/
                            assetInfoList.append(assetInfo)
                        }
                    }
                }
            }
        }
    }*/
    
    // Save Photo from UIImage
    func saveImageToPhotosLibrary(image: UIImage, completionHandler: ((Bool, NSError?) -> Void)?) {
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            
            PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            
            }, completionHandler: { success, error in
                completionHandler!(success, error)
        })
    }
    
    // Save Photo from URL
    func saveImageToPhotosLibrary(url: NSURL, completionHandler: ((Bool, NSError?) -> Void)?) {
    
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            
            PHAssetChangeRequest.creationRequestForAssetFromImageAtFileURL(url)
            
            }, completionHandler: { success, error in
                completionHandler!(success, error)
        })
    }
    
    // Save Video from URL
    func saveVideoToPhotosLibrary(url: NSURL, completionHandler: ((Bool, NSError?) -> Void)?) {
    
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            
            PHAssetChangeRequest.creationRequestForAssetFromVideoAtFileURL(url)
            
            }, completionHandler: { success, error in
                completionHandler!(success, error)
        })
    }
    
    // Delete Assets
    func deletaAssets(assets: [PHAsset], completionHandler: ((Bool, NSError?) -> Void)?) {
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
            
            PHAssetChangeRequest.deleteAssets(assets)
            
            }, completionHandler: { success, error in
                completionHandler!(success, error)
        })
    }
    
    // Metadata
    func metadata(url: NSURL) -> NSDictionary {
        
        let source: CGImageSourceRef = CGImageSourceCreateWithURL(url, nil)
        let dicRef: CFDictionaryRef = CGImageSourceCopyPropertiesAtIndex(source, 0, nil)
        let metadata: AnyObject = CFBridgingRetain(dicRef)
        
        return metadata as! NSDictionary
    }
    
    // Privacy Camera
    func autorizedCameraStatus(completionHandler: (AVAuthorizationStatus) -> ()) {
        
        let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        
        completionHandler(status)
    }
    
    // Privacy Photo
    func autorizedPhotoStatus(completionHandler: (PHAuthorizationStatus) -> ()) {
    
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        completionHandler(status)
    }
    
}
