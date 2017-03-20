import UIKit
import SDWebImage
import SCLAlertView

class PendingDebtController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var debtors: Array<Debt> = []

    var lendors: Array<Debt> = []

    var sections: Array<String> = ["Friends i owe money","Friends who owe me money"]
    
    let cellReuseIdentifier = "pendingDebtCell"
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate);
    
    let debtService = DebtService();

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self

        let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
        
        self.tableView.separatorColor = UIColor.turq
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.darkBlue
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.debtService.loadMy(type: "lenders", approved: false, completion: { (debtors) in
            self.debtors = debtors as! Array<Debt>;
            self.sections[0] = "Friends i owe money (\(self.lendors.count))";
            self.tableView.reloadData()
        })
        self.debtService.loadMy(type: "debtors", approved: false,  completion: { (lenders) in
            self.lendors = lenders as! Array<Debt>;
            self.sections[1] = "Friends who owe me money (\(self.lendors.count))";
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = TableViewHeader.instanceFromNib()
        header.titleLabel.text = self.sections [section ];
        
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if(section == 0){
            return self.debtors.count
        }
        else{
            return self.lendors.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var numOfSections: Int = 0
        if (self.debtors.count + self.lendors.count) > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = self.sections.count
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: tableView.bounds.size.height))
            noDataLabel.text          = "No charges waiting for approval"
            noDataLabel.textColor     = UIColor.white
            noDataLabel.font = UIFont (name: "FibonSans-Thin", size: 18)
            noDataLabel.textAlignment = .center
            noDataLabel.lineBreakMode = .byWordWrapping
            noDataLabel.numberOfLines = 2
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.section == 0){
            
            let alert = AlertView().defaultAlert()
            let debt : Debt = debtors[indexPath.row]

        
            alert.addButton("Correct") {
                self.debtService.approveDebt(debt: debt)
                
            }

            alert.showInfo("Confirm", subTitle: Phrases().returnRandomStringForDebtor(type: "owed") + " " + debt.currency + debt.amount + " to " + debt.lenderName , closeButtonTitle: "Cancel")
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HomeTableCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! HomeTableCell
        
        var array : NSArray = []
        var debt : Debt = Debt(data:["":""])
        
        if(indexPath.section == 0){
            array = self.debtors as NSArray
            debt = array[indexPath.row] as! Debt
            cell.configureForPendingLenders(debt:debt)
        }
        else{
            array = self.lendors as NSArray
            debt = array[indexPath.row] as! Debt
            cell.configureForPendingDebtors(debt: debt)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if(indexPath.section == 0){
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let array = self.lendors as NSArray
            let debt = array[indexPath.row] as! Debt
            self.debtService.deleteDebt(debt: debt)
        }
    }
    
    
}

