//
//  ImagePreviewViewController.swift
//  MyApp
//
//  Created by Thazin, Thin on 2/25/20.
//  Copyright © 2020 Thazin, Thin. All rights reserved.
//

import Foundation
import UIKit

class ImagePreviewViewController : UIViewController{
    
    var capturedImage :UIImage?
    
    @IBOutlet weak var ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ImageView.image = capturedImage
    }
}
