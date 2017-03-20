import UIKit
class HomeTableCell: UITableViewCell {
    
    @IBOutlet var checkmarkImage: UIImageView!
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var middleLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        
        self.layoutIfNeeded()
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.width/2
        self.profileImage.layer.masksToBounds = true
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.profileImage.layer.borderWidth = 2
        self.profileImage.layer.borderColor = UIColor.turq.cgColor
        
        self.tintColor = UIColor.turq
        self.backgroundColor = self.contentView.backgroundColor;
        
        self.rightLabel.textColor = UIColor.blue1
        self.middleLabel.textColor = UIColor.white
        self.leftLabel.textColor = UIColor.blue1
    }
    
    func configureForDebtors(debt:Debt) {
       
        self.leftLabel.text = Phrases().returnRandomStringForDebtor(type: "owed")

        if(debt.paid == true){
            self.leftLabel.text = Phrases().returnRandomStringForDebtor(type: "paid")
            self.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
        self.profileImage.sd_setImage(with: URL(string:debt.lenderImg), completed: nil)
        self.middleLabel.text = debt.lenderName
        self.rightLabel.text = debt.currency + debt.amount
        self.dateLabel.text = debt.timeAgo()
    }
    
    func configureForLendors(debt:Debt) {
        
        if(debt.paid == true){
            self.middleLabel.text = Phrases().returnRandomStringForLendor(type: "paid")
            self.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
        self.profileImage.sd_setImage(with: URL(string:debt.debtorImg), completed: nil)
        
        self.leftLabel.text = debt.debtorName
        self.middleLabel.text = Phrases().returnRandomStringForLendor(type: "owed")
        self.rightLabel.text = debt.currency + debt.amount
        self.dateLabel.text = debt.timeAgo()
    }
    
    func configureForFriendsList(user:User) {
        
        self.profileImage.sd_setImage(with: URL(string:user.img))
        self.leftLabel.text = user.name
        self.backgroundColor = UIColor.darkBlue
        self.backgroundColor = self.contentView.backgroundColor;
    }
    
    func configureForPendingLenders(debt:Debt) {
        
        self.profileImage.sd_setImage(with: URL(string:debt.lenderImg), completed: nil)
        self.leftLabel.text = debt.lenderName
        self.middleLabel.text =  Phrases().returnRandomStringForLendor(type: "pending")
        self.rightLabel.text = debt.currency + debt.amount
        
    }
    
    func configureForPendingDebtors(debt:Debt) {
        
        self.profileImage.sd_setImage(with: URL(string:debt.debtorImg), completed: nil)
        
        self.leftLabel.text = debt.debtorName
        self.middleLabel.text = Phrases().returnRandomStringForDebtor(type: "pending")
        self.rightLabel.text =  debt.currency + debt.amount
    }
    
    
}
private extension Array {
    var randomElement: Element {
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
}
