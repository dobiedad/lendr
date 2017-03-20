import UIKit
import FacebookLogin
import FirebaseAuth
import FacebookCore
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit

import NVActivityIndicatorView


class LoginViewController: UIViewController {
    @IBOutlet var loginButtonView: UIView!
    @IBOutlet var loginButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (AccessToken.current != nil) {
            AuthService().signIn(completion: { (res) in
                if res is String {
                    AlertView().defaultAlert().showError("oop", subTitle: res as! String)
                }
                else{
                    self.dismiss(animated: false, completion: nil)
                }
            })
        }

    }
    
    var ref: FIRDatabaseReference!
    
    func loadSpinner(){
        
        let rect = CGRect(x:0, y: 0, width: 60, height: 60)
        let activityIndicatorView = NVActivityIndicatorView(frame: rect, type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.white, padding: nil)
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        self.view.addSubview(activityIndicatorView)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email","public_profile","user_friends"], handler: { (result, error) -> Void in
            if (error == nil){
                if (result?.isCancelled)! {
                    return
                }
                self.loginButtonView.isHidden = true;
                self.loadSpinner()
                AuthService().signIn(completion: { (res) in
                    if res is User{
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            }
        })
    }
}

