import Foundation
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth

class UserService: NSObject {
    var ref: FIRDatabaseReference!
    var uid: String!
    
    init(fbid:String) {
        self.uid = FIRAuth.auth()?.currentUser?.uid
        self.ref = FIRDatabase.database().reference(withPath: "users").child(fbid)
    }
    
    func loadMyProfile(completion: @escaping (_ result: User)->()) {
        
        self.ref.observe(.value, with: { snapshot in
            if let result = snapshot.value {
                let dict = snapshot.value
                let user = User(data:dict as! Dictionary<String, Any>)
                completion(user)
            } else {
                
                print("no results")
            }
            
        
        })
        
    
    }
    
    func saveFBUser(data: FBUser , completion: @escaping (_ result: User)->()) {
        let user = User(data:data.dictionaryValue() as! Dictionary<String, Any>)
        let obj = user.dictionaryValue()
        self.ref.setValue(obj)
        FIRDatabase.database().reference(withPath: "firebaseIds").child(user.id).setValue(user.fbid)
        completion(user)
    }
    
}
