//
//  tabbarVC.swift
//  Sicily guide
//
//  Created by Дмитрий on 08.12.2019.
//  Copyright © 2019 DZ. All rights reserved.
//

import UIKit

class tabbarVC: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.overrideUserInterfaceStyle = Device.getInterfaceMode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if tabBar.items!.count > 0 {
            
            for i in tabBar.items! {
                i.image = i.image?.withRenderingMode(.alwaysOriginal)
                i.selectedImage = i.selectedImage?.withRenderingMode(.alwaysOriginal)
            }}
        
    }

}
