import UIKit
import FirebaseAuth
import SCLAlertView
import FBSDKShareKit

class FriendsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var friends: Array<User> = []
    
    let cellReuseIdentifier = "friendsCell"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTable()
        self.loadData()

    }
    
    @IBAction func inviteTapped(_ sender: Any) {
        let content = FBSDKAppInviteContent()
        content.appLinkURL = NSURL(string: "https://fb.me/274702332972860") as URL!
        content.appInvitePreviewImageURL = NSURL(string: "https://lendr-web.herokuapp.com/logo.png") as URL!
        FBSDKAppInviteDialog.show(from: self, with: content, delegate: self)
    }

    func loadData(){
        let alert = AlertView().noCloseButton()
        
        alert.showWait("Loading...", subTitle: "", closeButtonTitle: "", duration: 0, colorStyle: 169085, colorTextButton: 169085, circleIconImage: nil, animationStyle:.topToBottom)
        AuthService().getFriends(completion: { (array) in
            self.friends = array as! Array<User>
            alert.hideView()
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var numOfSections: Int = 0

        if (self.friends.count > 0){
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: tableView.bounds.size.height))
            noDataLabel.text          = "Non of your facebook friends seem to be using lendr"
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
    
    func setupTable(){
        let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        
        self.tableView.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor.turq
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.darkBlue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99;
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HomeTableCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! HomeTableCell
        let array : NSArray = self.friends as NSArray
        let user : User = array[indexPath.row] as! User
        
        cell.configureForFriendsList(user: user)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let array : NSArray = self.friends as NSArray
        
        let user : User = array[indexPath.row] as! User

        let alert = AlertView().noCloseButton()
        let successAlert = AlertView().defaultAlert()

        let label = alert.addTextField("Amount")
        alert.addButton("Create") {
            if(label.text?.isNumber)!{
                let dict = ["debtor":user.fbid,"lender":appDelegate.currentUser?.fbid ?? "" ,"amount":label.text ?? "","paid":false,"debtorImg":user.img,"lenderImg":appDelegate.currentUser?.img ?? "","debtorName":user.name,"lenderName":appDelegate.currentUser?.name ?? "","currency":DebtService().currencyString()] as [String : Any]
                let debt =  Debt.init(data: dict)
                
                DebtService().create(debt: debt, completion: { 

                    let message : String = "Waiting for " + debt.debtorName + " to approve"
                    successAlert.showSuccess("Debt Created", subTitle: message )

                })

            }
            else{
                
            }
        }
        
        
        alert.showEdit("New Debt", subTitle: "How much does "
            + user.name +  " owe you?")
        
    }
    
}

extension FriendsController: FBSDKAppInviteDialogDelegate{
    /**
      Sent to the delegate when the app invite encounters an error.
     - Parameter appInviteDialog: The FBSDKAppInviteDialog that completed.
     - Parameter error: The error.
     */
    public func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
        print("yo")
    }


    public func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        let alert = AlertView().defaultAlert()
        
        if(results != nil){
            alert.showSuccess(String(results.count) + " Invited", subTitle: " friends will appear here when they install lendr")

        }
        
    }

    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        //TODO
    }
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        //TODO
    }
}
