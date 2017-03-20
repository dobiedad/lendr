import Foundation

public class Phrases: NSObject {
    
    var debtors:Dictionary<String,Array<String>>;
    var lendors:Dictionary<String,Array<String>>;

    
    override init() {
        self.debtors = [
            "paid":[
                "You Paid",
                "You resolved a debt of",
                "You paid",
                "You reimbursed",
                "You returned",
                "You settled"
            ],
            "owed":[
                "You owe",
                "You have borrowed",
                "You need to resolve a debt of",
                "You have to pay",
                "You need to reimburse",
                "You need to return",
                "You need to settle"
            ],
            "pending":[
                "needs to approve debt of",
                "needs to confirm owing",
                "must accept debt of",
                "is required to confirm debt of"
            ]
        ]
        self.lendors = [
            "paid":[
                "paid you",
                "reimbursed you",
                "has compensated you",
                "has returned",
                "given back",
                "has settled",
                "has resolved a debt of"
            ],
            "owed":[
                "owe's you",
                "needs to reimburse you",
                "has to pay you",
                "needs to return",
                "has an outstanding payment",
                "needs to settle",
                "has to resolve a debt of"
                
            ],
            "pending":[
                "claims you owe",
                "has stated you owe",
                "declares the damage is",
                "insists the liability is",
                "alleges you're in the red for",
            ]
        ]
    }
    
    func returnRandomStringForDebtor(type:String) -> String{
      return self.randomStringForArray(array: self.debtors[type]!)
        
    }
    
    func returnRandomStringForLendor(type:String) -> String{
        return self.randomStringForArray(array: self.lendors[type]!)
        
    }
    
    func randomStringForArray(array:Array<String>) ->  String {
    
        return (array.randomElement)
    }

}
private extension Array {
    var randomElement: Element {
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
}
