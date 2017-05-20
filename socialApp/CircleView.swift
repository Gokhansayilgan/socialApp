//
//  CircleView.swift
//  socialApp
//
//  Created by Gökhan Sayılgan on 12/05/17.
//  Copyright © 2017 Gökhan Sayılgan. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    

    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width/2
        clipsToBounds = true 
    }
    
        
    
}
