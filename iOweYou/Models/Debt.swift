import Foundation
import FirebaseAuth
import DateToolsSwift

public class Debt: NSObject {
    
    var debtor:String;
    var lender:String;
    var amount:String
    var debtorName:String;
    var lenderName:String
    var currency:String

    var lenderImg:String;
    var debtorImg:String
    var createdAt:Date
    var id:String
    var paid:Bool;
    var approved:Bool;

    
    init(data: Dictionary<String, Any>) {
        
        self.debtor = data["debtor"] != nil ?  data["debtor"] as! String : ""
        self.lender = data["lender"] != nil ? data["lender"] as! String : ""
        self.debtorName = data["debtorName"] != nil ? data["debtorName"] as! String : ""
        self.lenderName = data["lenderName"] != nil ? data["lenderName"] as! String : ""
        
        self.lenderImg = data["lenderImg"] != nil ? data["lenderImg"] as! String : ""
        self.debtorImg = data["debtorImg"] != nil ? data["debtorImg"] as! String : ""
        
        self.amount = data["amount"] != nil ? data["amount"] as! String : ""

        self.amount = data["amount"] != nil ? data["amount"] as! String : ""
        self.paid = (data["paid"] != nil) ? (data["paid"] as? Bool)! : false
        self.approved = (data["approved"] != nil) ? (data["approved"] as? Bool)! : false
        
        self.id = data["id"] != nil ?  data["id"] as! String : UUID().uuidString
        self.createdAt = data["createdAt"] != nil ? Date(timeStamp:(data["createdAt"] as! UInt64) ) : Date()
        self.currency = data["currency"] != nil ? data["currency"] as! String : ""

    }
    
    
    func dictionaryValue() -> (NSDictionary) {

        let dict = ["debtor":self.debtor,"lender":self.lender,"lenderImg":self.lenderImg,"currency":self.currency,"debtorImg":self.debtorImg,"createdAt":self.createdAt.timeStamp,"amount":self.amount,"paid":self.paid,"id":self.id,
                    "debtorName":self.debtorName,"lenderName":self.lenderName] as [String : Any]
        return dict as (NSDictionary)
    }
    
    func timeAgo() -> (String) {
        return self.createdAt.timeAgoSinceNow
    }
    
}
extension Date {
    init(timeStamp: UInt64) {
        self.init(timeIntervalSince1970: Double(timeStamp)/10_000_000 - 62_135_596_800)
    }
    var timeStamp: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
