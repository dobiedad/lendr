import UIKit

class LendrButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 2.0
        clipsToBounds = true
    }
}
