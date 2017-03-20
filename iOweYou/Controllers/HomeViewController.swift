import UIKit
import SDWebImage
import SCLAlertView
import NVActivityIndicatorView

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var oweTitle: UILabel!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var owedTitle: UILabel!
    
    @IBOutlet var notificationView: UIView!
    
    @IBOutlet var imOwedLabel: UILabel!
    
    @IBOutlet var iOweLabel: UILabel!
    
    @IBOutlet var notificationLabel: UILabel!
    
    var debtors: Array<Debt> = []
    
    var lendors: Array<Debt> = []
    
    var detailsHidden :Bool = true;
    
    var loadCount : Int = 0;

    var sections: Array<String> = ["Friends who owe me money","Friends i owe money"]
    
    let cellReuseIdentifier = "homeCell"
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate);
    
    let debtService = DebtService();
    
    var alert : SCLAlertView?

    var activityIndicatorView : NVActivityIndicatorView?
    
    override func viewDidLoad() {

        self.setupView()
        
        self.setupTable()
        
        self.setupNav()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.loadData()
//        self.loadSpinner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func loaded(){
       self.loadCount += 1
        if(loadCount == 3){
            alert?.hideView()
            loadCount = 0
        }
    }
    
    func loadSpinner(){
        
        let rect = CGRect(x:0, y: 0, width: 60, height: 60)
        self.activityIndicatorView = NVActivityIndicatorView(frame: rect, type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.white, padding: nil)
        self.activityIndicatorView?.center = self.view.center
        self.activityIndicatorView?.startAnimating()
        
        self.view.addSubview(activityIndicatorView!)
    }
    
    func loadData(){

        
        self.debtService.loadMy(type: "lenders", approved: true, completion: { (debtors) in
            
            self.debtors = debtors as! Array<Debt>;
            self.iOweLabel.text = self.debtService.currencyString() + self.debtService.calculateTotalDebt(array: self.debtors)
            let notPaid = self.debtors.filter( { !($0.paid) })
            
            self.sections[1] = "Friends i owe money (\(notPaid.count))"
            
            self.loaded()
            self.tableView.reloadData()
        })
        self.debtService.loadMy(type: "debtors", approved: true,  completion: { (lenders) in
            self.lendors = lenders as! Array<Debt>;
            self.imOwedLabel.text = self.debtService.currencyString() + self.debtService.calculateTotalDebt(array: self.lendors)
            let notPaid = self.lendors.filter( { !($0.paid) })
            
            self.sections[0] = "Friends who owe me money (\(notPaid.count))";
            self.loaded()
            
            self.tableView.reloadData()
        })
        
        self.debtService.loadMy(type: "lenders", approved: false, completion: { (debtors) in
            if(debtors.count > 0){
                self.notificationLabel.text = String(debtors.count)
                self.notificationView.isHidden = false;
            }
            else{
                self.notificationView.isHidden = true;
            }
            self.loaded()
            self.tableView.reloadData()
        })
    }
    
    func setupView(){
        profileImage.sd_setImage(with: URL(string: (appDelegate.currentUser?.img)!))
        profileImage.layer.cornerRadius = profileImage.layer.bounds.width/2
        profileImage.layer.borderWidth = 4
        profileImage.layer.borderColor = UIColor.turqDark.cgColor
        profileImage.layer.masksToBounds = true
        notificationView.layer.cornerRadius = notificationView.bounds.width/2
        self.notificationView.isHidden = true;
        self.nameLabel.text = self.appDelegate.currentUser?.name
    }
    
    func setupTable(){
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "homeCell")
    }
    
    func setupNav(){
        let nav = self.navigationController?.navigationBar.topItem
        self.tableView.separatorColor = UIColor.turq
        nav?.title = "lendr"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func setOpacityForDetailLabels(opacity:CGFloat){
        self.iOweLabel.alpha = opacity
        self.imOwedLabel.alpha = opacity
        self.nameLabel.alpha = opacity
        self.oweTitle.alpha = opacity
        self.owedTitle.alpha = opacity
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


        if(section == 1){
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
            noDataLabel.text          = "No approved debts. Press + to create a debt"
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
            let debt : Debt = lendors[indexPath.row]

            if(debt.paid == false){
                let alert = AlertView().defaultAlert()
                
                
                alert.addButton("Confirm") {
                    self.debtService.resolveDebt(debt: debt)
                    
                }
                let message = debt.debtorName + " paid you  " + debt.currency + debt.amount
                alert.showInfo("", subTitle:message , closeButtonTitle: "Cancel")
            }
      
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HomeTableCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! HomeTableCell
        
        var array : NSArray = []
        var debt : Debt = Debt(data:["":""])
        cell.accessoryType = UITableViewCellAccessoryType.none

        if(indexPath.section == 1){
            array = self.debtors as NSArray
            debt = array[indexPath.row] as! Debt
            
            cell.configureForDebtors(debt:debt)
      
        }
        else{
            array = self.lendors as NSArray
            debt = array[indexPath.row] as! Debt
            cell.configureForLendors(debt: debt)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.section == 1){
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
    
    
    @IBAction func imageButtonTappe(_ sender: Any) {
        self.detailsHidden = !self.detailsHidden
        
        if(self.detailsHidden) {
            UIView.animate(withDuration: 0.3, animations: {
                self.setOpacityForDetailLabels(opacity: 1)
                
            }, completion: nil)
        }
        else{
            UIView.animate(withDuration: 0.3, animations: {
                self.setOpacityForDetailLabels(opacity: 0)
            }, completion: nil)
        }
        
        
    }
    
    @IBAction func signoutTapped(_ sender: Any) {
        AuthService().signOut {
            self.performSegue(withIdentifier: "transitionToRoot", sender: self)
        }
    }
    

}

