import UIKit
import SDWebImage

class DebtViewController: UIViewController {

    @IBOutlet var debtAmount: UILabel!
    @IBOutlet var timeAgo: UILabel!

    @IBOutlet var netAmount: UILabel!
    @IBOutlet var youOweAmount: UILabel!
    @IBOutlet var owesYouAmount: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var creatorView: UIView!

    @IBOutlet var paidImage: UIImageView!
    
    var debt: Debt?

    let debtService = DebtService();

    var selectedType :String?

    override func viewDidLoad() {
        profileImage.layer.cornerRadius = profileImage.layer.bounds.width/2
        profileImage.layer.borderWidth = 4
        profileImage.layer.borderColor = UIColor.turqDark.cgColor
        profileImage.layer.masksToBounds = true

        self.setupView()

    }

    func setupView() {
        let netLabel:String?
        let zero = 0.00
    if (self.selectedType == "debtors"){
            let net = self.debtService.calculateNetForUser(fbid: (self.debt?.debtor)!)
            self.profileImage.sd_setImage(with: URL(string: (self.debt?.debtorImg)!))
            self.title = self.debt?.debtorName
            if (Double(net)! > zero) {
                netLabel = "Owes you "
            }
            else{
                netLabel = "You owe "
            }
            self.netAmount.text = netLabel! + String(describing: Double(net)?.absoluteValue)
            self.creatorView.isHidden = (self.debt?.paid)!

            self.owesYouAmount.text = self.debtService.formatCurrency(value:Double(self.debtService.calculateTotalImOwedFrom(fbid: (self.debt?.debtor)!))!)
            self.youOweAmount.text = self.debtService.formatCurrency(value:Double(self.debtService.calculateTotalIOweTo(fbid: (self.debt?.debtor)!))!)
        }
        else{
            let net = self.debtService.calculateNetForUser(fbid: (self.debt?.lender)!)

            self.profileImage.sd_setImage(with: URL(string: (self.debt?.lenderImg)!))
            self.title = self.debt?.lenderName

            if (Double(net)! > zero) {
                netLabel = "Owes you "
            }
            else{
                netLabel = "You owe "
            }
            self.netAmount.text = netLabel! + String(describing: Double(net)?.absoluteValue)

            self.owesYouAmount.text = self.debtService.formatCurrency(value:Double(self.debtService.calculateTotalImOwedFrom(fbid: (self.debt?.lender)!))!)
            self.youOweAmount.text = self.debtService.formatCurrency(value:Double(self.debtService.calculateTotalIOweTo(fbid: (self.debt?.lender)!))!)
        }
       
        self.debtAmount.text = self.debtService.formatCurrency(value:Double(debt!.amount)!)
        self.timeAgo.text = self.debt?.timeAgo()
    
        self.paidImage.isHidden = !(self.debt?.paid)!;
    }
    
    func setUpDebt(type:String, debt:Debt) {
        self.debt = debt
        self.selectedType = type
    }

    
    
    @IBAction func markAsPaidTapped(_ sender: Any) {
        let alert = AlertView().defaultAlert()
        
        
        alert.addButton("Confirm") {
            self.debtService.resolveDebt(debt: self.debt!)
            self.debt?.paid = true;
            self.setupView()
            
        }
        let message = (self.debt?.debtorName)! + " paid you  " + self.debtService.formatCurrency(value: Double((self.debt?.amount)!)!)
        alert.showInfo("", subTitle:message , closeButtonTitle: "Cancel")
    }
    @IBAction func deleteTapped(_ sender: Any) {
        let alert = AlertView().defaultAlert()

        alert.addButton("Confirm") {
            self.debtService.deleteDebt(debt: self.debt!)
            self.navigationController?.popViewController(animated: true)
            
        }
        let message = "Delete debt for " + self.debtService.formatCurrency(value: Double((self.debt?.amount)!)!) + " ?"
        alert.showInfo("Warning", subTitle:message , closeButtonTitle: "Cancel")
 
    }
}

extension Double {
    var absoluteValue: Double {
    if self > 0.0 {
        return self
    }
    else {
        return -1 * self
        }
    }
}
