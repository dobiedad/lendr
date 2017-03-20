import UIKit
import SCLAlertView

class AlertView: SCLAlertView {
    
    func noCloseButton() -> SCLAlertView {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "FibonSans-Thin", size: 20)!,
            kTextFont: UIFont(name: "FibonSans-Thin", size: 14)!,
            kButtonFont: UIFont(name: "FibonSans-Thin", size: 14)!,
            showCloseButton: false,
            hideWhenBackgroundViewIsTapped: true
        )
        let alert = SCLAlertView(appearance: appearance)
        
        return alert
    }
    
    func defaultAlert() -> SCLAlertView {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "FibonSans-Thin", size: 20)!,
            kTextFont: UIFont(name: "FibonSans-Thin", size: 14)!,
            kButtonFont: UIFont(name: "FibonSans-Thin", size: 14)!,
            hideWhenBackgroundViewIsTapped: true
        )
        let alert = SCLAlertView(appearance: appearance)
        
        return alert
    }
}
