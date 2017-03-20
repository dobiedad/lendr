import FacebookCore

struct MyProfileRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        var user: FBUser;
        init(rawResponse: Any?) {
            self.user = FBUser(data: rawResponse as! Dictionary<String, Any>)
        }
    }
    
    var graphPath = "/me"
    var parameters: [String : Any]? = AuthService().fbParams()
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}
