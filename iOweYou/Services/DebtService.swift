import Foundation
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth

class DebtService: NSObject {
    var ref: FIRDatabaseReference!
    var uid: String!
    var app: AppDelegate!
    
    override init() {
        self.uid = FIRAuth.auth()?.currentUser?.uid
        self.ref = FIRDatabase.database().reference(withPath: "debt")
        self.app = UIApplication.shared.delegate as! AppDelegate
    }
    
    func create(debt:Debt, completion: @escaping ()->()) {
        let obj = debt.dictionaryValue()
        self.ref.child(debt.id).setValue(obj)
        completion()
    }
    
    func loadMy(type:String, approved:Bool, completion: @escaping (_ result: NSArray)->()) {
        let child = type == "lenders" ? "debtor" : "lender"
        var debtors : Array<Debt?> = []
        self.ref.queryOrdered(byChild: child).queryEqual(toValue:self.app.currentUser?.fbid).observe(.value, with: { snapshot in
            debtors = []
            if let postDict = snapshot.value as? Dictionary<String, AnyObject> {
                for user in postDict {
                    
                    let debt = Debt(data: user.value as! Dictionary<String, Any>)
                    if(approved){
                        if(debt.approved == true){
                            debtors.append(debt)
                        }
                    }
                    else{
                        if(debt.approved == false){
                            debtors.append(debt)
                        }
                    }
                 
                }
                let array = debtors.sorted(by: { ($0?.createdAt)! > ($1?.createdAt)! }) as NSArray;

                completion(array)
            }
            else {
                completion([])
                print("no results")
            }
            
            
        })
    }
    
    func resolveDebt(debt:Debt){
        debt.paid = true;
        self.ref.child(debt.id + "/paid").setValue(true)
    }
    
    func approveDebt(debt:Debt){
        debt.approved = true;
        debt.paid = false;
        self.ref.child(debt.id + "/approved").setValue(true)
    }
    
    func deleteDebt(debt:Debt){
        self.ref.child(debt.id).removeValue()
    }
    
    func calculateTotalDebt(array:Array<Debt>) -> String{
        var total = 0.00;
        
        for i in array {
            if(i.paid == false){
                total += Double(i.amount)!
            }
        }
        return String(total)
    }
    
    func calculateTotalIOweTo(fbid:String) -> String{
        var total = 0.00;
        
        for i in self.app.debtors {
            if(i?.lender == fbid){
                
                if(i?.paid == false){
                    total += Double((i?.amount)!)!
                }
            }
        }
        return String(total)
    }
    
    func calculateTotalImOwedFrom(fbid:String) -> String{
        var total = 0.00;
        
        for i in self.app.lendors {
            if(i?.debtor == fbid){
                if(i?.paid == false){
                    total += Double((i?.amount)!)!
                }
            }
        }
        return String(total)
    }
    
    func calculateNetForUser(fbid:String) -> String{
        var total = Double(self.calculateTotalImOwedFrom(fbid:fbid))! - Double(self.calculateTotalIOweTo(fbid: fbid))!;
        
       
        return  String(total)
    }

    func formatCurrency(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2;
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let result = formatter.string(from: value as NSNumber);
        return result!;
    }
    
    func currencyString() -> (String){
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol
        return currencySymbol!
    }
}

extension String  {
    var isNumber : Bool {
        get{
            if NumberFormatter().number(from: self) != nil {
                return true
            } else {
                return false
            }
            
        }
    }
}
