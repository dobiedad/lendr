import Foundation
@testable import iOweYou

var data : Dictionary = ["id":UUID().uuidString, "name": "john","fbid":UUID().uuidString,"email":"leo@123.com","img":"google.com/image.png"]

class UserBuilder: AnyObject {
    var user: User?

    init() {
        self.user = User(data:data)
    }
    
    convenience init(name:String) {
        data["name"] = name
        self.init()
    }
    
    func buildUser() -> User {
        return self.user!
    }
}
