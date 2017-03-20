import Foundation
import FirebaseAuth

public class User: NSObject {
    
    var id:String;
    var name:String;
    var fbid:String;
    var email:String;
    var img:String;

    init(data: Dictionary<String, Any>) {
        self.id = data["id"] != nil ? data["id"] as! String : (FIRAuth.auth()?.currentUser?.uid)!
        self.name = data["name"] as! String
        self.fbid = data["fbid"] as! String
        self.email = data["email"] as! String
        self.img = data["img"] as! String
    }
    
    func dictionaryValue() -> (NSDictionary) {
        let dict = ["id":self.id,"name":self.name,"fbid":self.fbid,"email":self.email,"img":self.img]
        return dict as (NSDictionary)
    }
}
