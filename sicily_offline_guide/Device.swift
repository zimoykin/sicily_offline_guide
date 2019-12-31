import UIKit

class Device {
    static func vibrate() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    static func getInterfaceMode () -> UIUserInterfaceStyle {
        
        if UserDefaults.standard.bool(forKey: "darkMode"){
             return UIUserInterfaceStyle.dark
        }
        return UIUserInterfaceStyle.light
    }
}
