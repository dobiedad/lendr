import Foundation
import FirebaseAuth
import FBSDKLoginKit
import FacebookLogin
import FirebaseAuth
import FacebookCore

class AuthService: NSObject {
    
    var myFriends: [User] = []
    
    
    func getFbCredentials() -> NSObject {
        return FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
    }
    
    
    func getFbFriends(completion: @escaping (_ result: NSArray)->()) {
        let graphRequest = GraphRequest(graphPath: "me/taggable_friends", parameters: self.fbParams())
        graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult {
            case .failed(let error):
                print("error in graph request:", error)
                completion([])
                break
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    print(responseDictionary)
                    completion((responseDictionary["data"] as! NSArray))
                    print((responseDictionary["data"] as! NSArray).count)
                }
            }
        }
    }

    func signIn(completion: @escaping (_ result: AnyObject)->()){
        
        FIRAuth.auth()?.signIn(with: self.getFbCredentials() as! FIRAuthCredential) { (user, error) in

            self.loadFacebookDetails(completion: { (fbuser) in
                print(object_getClass(fbuser))
                
                
                if fbuser is FBUser {
                    let service = UserService(fbid:(fbuser as! FBUser).fbid)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    appDelegate.setCurrent(user:User(data:(fbuser as! FBUser).dictionaryValue() as! Dictionary<String, Any>))
                    
                    service.saveFBUser(data: fbuser as! FBUser, completion: { (user) in
                        completion(user)
                    })
                }
                else {
                    completion((fbuser as! NSError).localizedDescription as AnyObject)
                }
                
            });


        }
    }
    
    func signOut(completion: @escaping ()->()){
        
        guard (try? FIRAuth.auth()!.signOut()) != nil else {
            return
        }
        LoginManager().logOut()
        completion()
    }
    
    func getFriends(completion: @escaping (_ result: NSArray)->()) {
        let graphRequest = GraphRequest(graphPath: "me/friends", parameters: self.fbParams())
        graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult {
            case .failed(let error):
                print("error in graph request:", error)
                completion([])
                break
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    print(responseDictionary)
                    
                    
                    let friends:NSArray = self.convertFbUsersTo(users: self.arrayOfFB(users: (responseDictionary["data"] as! NSArray) as! [Any]) ) as NSArray

                    
                    print((responseDictionary["data"] as! NSArray).count)
                    
                    completion(friends.sorted { ($0 as! User).name < ($1 as! User).name } as NSArray)
                }
            }
        }
    }
    
    func loadFacebookDetails(completion: @escaping (AnyObject)->()){
        let connection = GraphRequestConnection()
        connection.add(MyProfileRequest()) { response, result in
            switch result {
            case .success(let response):
                completion(response.user)
                print("Custom Graph Request Succeeded: \(response.user)")
            case .failed(let error):
                completion(error as AnyObject)
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
    
    func arrayOf(users: [Any]) -> [Any] {
        var converted = [User?]()
        for i in 0..<users.count {
            let user =  User(data:users[i] as! Dictionary<String, Any>)
            converted.insert(user, at: i)
        }
        return converted
    }
    
    func fbParams() -> Dictionary<String,Any> {
        let params = ["fields": "id, name,email,picture.width(400).height(400)","limit":"5000"]
        return params
    }
    
    
    func convertFbUsersTo(users: [Any]) -> [Any] {
        var converted = [User?]()
        for i in 0..<users.count {
            let user =  User(data:(users[i] as! FBUser).dictionaryValue() as! Dictionary<String, Any>)
            converted.insert(user, at: i)
        }
        return converted
    }
    
    func arrayOfFB(users: [Any]) -> [Any] {
        var converted = [FBUser?]()
        for i in 0..<users.count {
            let user =  FBUser(data:users[i] as! Dictionary<String, Any>)
            converted.insert(user, at: i)
        }
        return converted
    }
}

