import Foundation
import FirebaseAuth

public class FBUser: NSObject {
    
    var fbid:String;
    var name:String;
    var email:String
    var img:String
    
    init(data: Dictionary<String, Any>) {
        self.fbid = data["id"] as! String;
        self.name = data["name"] as! String
        self.email = data["email"] != nil ?  data["email"] as! String : ""
        let pic =  data["picture"] as! NSDictionary
        let dat =  pic["data"] as! NSDictionary
        self.img = dat["url"] as! String
    }
    
    func dictionaryValue() -> (NSDictionary) {
        let dict = ["fbid":self.fbid,"name":self.name,"email":self.email,"img":self.img]
        return dict as (NSDictionary)
    }
    
}
