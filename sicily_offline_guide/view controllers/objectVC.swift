

import UIKit
//import MapKit
//import CoreLocation

class objectVC: UIViewController {
    
    var uuid: UUID?
    
    override func viewWillAppear(_ animated: Bool) {
        self.overrideUserInterfaceStyle = Device.getInterfaceMode()
    }

    
//    MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = Device.getInterfaceMode()


//        BUTTON
        let cancelBTN = UIButton(type: .close)
        
        cancelBTN.frame = CGRect(x: 100, y: 100, width: 150, height: 25)
        
        cancelBTN.setTitle("Cancel", for: .normal)
        cancelBTN.setTitleColor(.black, for: .normal)
        cancelBTN.addTarget(self, action: #selector(pushcancel), for: .touchUpInside)
      
        
        view.addSubview(cancelBTN)
        
 
        
    }
    
    
    @objc func pushcancel() {
        
        print("Cancel")
        
    }
}
//
//
////    MARK: mapkit
//extension objectVC: MKMapViewDelegate {
//
//}
