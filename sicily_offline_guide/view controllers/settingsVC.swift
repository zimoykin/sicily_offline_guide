//
//  settingsVC.swift
//  Sicily guide
//
//  Created by Дмитрий on 20.12.2019.
//  Copyright © 2019 DZ. All rights reserved.
//

import UIKit

class settingsVC: UIViewController {

    let screen_width    = UIScreen.main.bounds.width
    let screen_height   = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: screen_width-10, height: screen_height-10))
        
        image.image = UIImage(named: "nophoto.png")
        image.clipsToBounds =  true
        image.contentMode = .scaleAspectFill
        
        image.center = view.center
        
        view.addSubview(image)
        
        let textview = UITextView(frame: CGRect(x: 0, y: 0, width: screen_width-10, height: screen_height-10))
        
        textview.text = "login FACEBOOK have status under consstruction"
        textview.sizeToFit()
        textview.textColor = .white
        textview.textAlignment = .center
        textview.backgroundColor = .black
        textview.frame.origin.y = image.frame.midY
        
        view.addSubview(textview)
    }
    

}
