//
//  tabbarVC.swift
//  Sicily guide
//
//  Created by Дмитрий on 08.12.2019.
//  Copyright © 2019 DZ. All rights reserved.
//

import UIKit

class tabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if tabBar.items!.count > 0 {
            
            for i in tabBar.items! {
                i.image = i.image?.withRenderingMode(.alwaysOriginal)
                i.selectedImage = i.selectedImage?.withRenderingMode(.alwaysOriginal)
            }}
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
