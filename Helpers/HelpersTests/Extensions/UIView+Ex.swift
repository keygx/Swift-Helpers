//
//  UIView+Ex.swift
//
//  Created by keygx on 2015/08/04.
//  Copyright (c) 2015年 keygx. All rights reserved.
//

import UIKit

extension UIView {
    
    func toImage() -> UIImage? {
    
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0.0, 0.0)
        self.layer.renderInContext(context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}