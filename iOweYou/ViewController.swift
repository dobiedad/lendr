import UIKit
import FacebookLogin
import FirebaseAuth
import FacebookCore
import FirebaseDatabase



class ViewController: UIViewController,LoginButtonDelegate {
    
    override func viewDidLoad() {
        if (AccessToken.current != nil) {
//            AuthService().signIn(completion: { (user) in
//                self.loadMyProfile(completion: { (user:User) in
//                });
//            })
            AuthService().getFbFriends()
          
        }
        else{
            let loginButton = LoginButton(readPermissions: [ .publicProfile , .email, .userFriends ])
            loginButton.center = view.center
            loginButton.delegate = self;
            
            view.addSubview(loginButton)
        }
    }
    
    var ref: FIRDatabaseReference!
    
    func loadMyProfile(completion: @escaping (_ result: User)->()) {
        let userID = FIRAuth.auth()?.currentUser?.uid

        FIRDatabase.database().persistenceEnabled = false
        
        ref = FIRDatabase.database().reference(withPath: "users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as! [String: [String:String]]
            let user = User(data:dict)
            completion(user)
        })
        let chatsRef = ref.child("chats")
        chatsRef.observe(.value, with: { snapshot in
            print("Hello, World")
        })
        
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        AuthService().getFbFriends()
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
    }

}

