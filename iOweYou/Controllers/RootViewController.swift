import UIKit
import FacebookLogin
import FirebaseAuth
import FacebookCore
import FBSDKCoreKit
import NVActivityIndicatorView

class RootViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
 
        self.loadSpinner()
        
        if (AccessToken.current != nil) {
            AuthService().signIn(completion: { (res) in
                if let stringArray = res as? String {
                    self.performSegue(withIdentifier: "transitionToLogin", sender: self)
                }
                else{
                    self.performSegue(withIdentifier: "transitionToHomeVC", sender: self)
                }
            })
        }
        else{
            self.performSegue(withIdentifier: "transitionToLogin", sender: self)
        }

    }
    
    func loadSpinner(){

        let rect = CGRect(x:0, y: 0, width: 60, height: 60)
        let activityIndicatorView = NVActivityIndicatorView(frame: rect, type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.white, padding: nil)
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        self.view.addSubview(activityIndicatorView)
    }
    
}

