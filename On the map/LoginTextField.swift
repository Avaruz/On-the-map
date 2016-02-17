//
//  LoginLabel.swift
//  On the Map
//
//  Created by Ra Ra Ra on 5/18/15.
//  Copyright (c) 2015 Ra Ra Ra. All rights reserved.
//

import UIKit

@IBDesignable
class LoginTextField: UITextField {
    
    @IBInspectable var xInset: CGFloat = 10
    @IBInspectable var yInset: CGFloat = 5
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, xInset, yInset)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
    
}
