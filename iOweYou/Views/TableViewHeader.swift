import UIKit
class TableViewHeader: UIView {

    @IBOutlet var titleLabel: UILabel!
    
    class func instanceFromNib() -> TableViewHeader {
        return UINib(nibName: "TableViewHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TableViewHeader
    }
}
