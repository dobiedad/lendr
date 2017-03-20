import Foundation
import CoreData


extension Friends {
    private func convertJSONStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func save(data: AnyObject) {    
        self.data = data as? NSData
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friends> {
        return NSFetchRequest<Friends>(entityName: "Friends");
    }
    
    @NSManaged public var data: NSData?
}
