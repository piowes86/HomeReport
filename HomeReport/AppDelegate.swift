import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coredata = CoreDataStack()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        checkDataStore()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coredata.saveContext()
    }

    func checkDataStore() {
        let request: NSFetchRequest<Home> = Home.fetchRequest()
        
        let moc = coredata.persistentContainer.viewContext
        do {
            let homeCount = try moc.count(for: request)
            
            if homeCount == 0 {
                uploadSampleData()
            }
        }
        catch {
            fatalError("Error in counting home record")
        }
    }
    
    func uploadSampleData() {
        let moc = coredata.persistentContainer.viewContext
        
        let url = Bundle.main.url(forResource: "homes", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            let jsonArray = jsonResult.value(forKey: "home") as! NSArray
            
            //var home: NSManagedObject?
            for json in jsonArray {
                let homeData = json as! [String: AnyObject]
                
                // Location
                guard let city = homeData["city"] else {
                    return
                }
                
                // Price
                guard let price = homeData["price"] else {
                    return
                }
                
                // Bed
                guard let bed = homeData["bed"] else {
                    return
                }
                
                // Bath
                guard let bath = homeData["bath"] else {
                    return
                }
                
                // Sqft
                guard let sqft = homeData["sqft"] else {
                    return
                }
                
                // Picture
                var image: UIImage?
                if let currentImage = homeData["image"] {
                    let imageName = currentImage as? String
                    image = UIImage(named: imageName!)
                }
                
                // Home type
                guard let homeCategory = homeData["category"] else {
                    return
                }
                let homeType = (homeCategory as! NSDictionary)["homeType"] as? String
                
                // Home status
                guard let homeStatus = homeData["status"] else {
                    return
                }
                let isForSale = (homeStatus as! NSDictionary)["isForSale"] as? Bool
                
                // Home object initialization
                let home = homeType?.caseInsensitiveCompare("condo") == .orderedSame ? Condo(context: moc) : SingleFamily(context: moc)
                home.price = price as! Double
                home.bed = bed.int16Value
                home.bath = bath.int16Value
                home.sqft = sqft.int16Value
                home.image = NSData.init(data: UIImageJPEGRepresentation(image!, 1)!)
                home.homeType = homeType
                home.city = city as? String
                home.isForSale = isForSale!
                
                if let unitsPerBuilding = homeData["unitsPerBuilding"] {
                    (home as! Condo).unitsPerBuilding = unitsPerBuilding.int16Value
                }
                
                if let lotSize = homeData["lotSize"] {
                    (home as! SingleFamily).lotSize = lotSize.int16Value
                }
                
                // Sale history
                if let saleHistories = homeData["saleHistory"] {
                    let saleHistoryData = home.saleHistory?.mutableCopy() as! NSMutableSet
                    
                    for saleDetail in saleHistories as! NSArray {
                        let saleData = saleDetail as! [String: AnyObject]
                        
                        let saleHistory = SaleHistory(context: moc)
                        saleHistory.soldPrice = saleData["soldPrice"] as! Double
                        
                        let soldDateStr = saleData["soldDate"] as? String
                        /*let dateFormatter = DateFormatter()
                         let soldDate = dateFormatter.date(from: soldDateStr!)*/
                        saleHistory.soldDate = soldDateStr
                        
                        saleHistoryData.add(saleHistory)
                        home.saleHistory = saleHistoryData.copy() as? NSSet
                    }
                    
                    
                }
            }
            
            coredata.saveContext()
        }
        catch {
            fatalError("Cannot upload sample data")
        }
    }
}

