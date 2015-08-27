//
//  RoundImageView.swift
//  IMtest
//
//  Created by xiaobo on 15/7/20.
//  Copyright © 2015年 xiaobo. All rights reserved.
//

import UIKit

@IBDesignable
class RoundImageView: UIImageView {

    /**圆角图片*/
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }
    
    
    
    

}
