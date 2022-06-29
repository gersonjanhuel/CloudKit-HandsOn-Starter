//
//  CloudKit_HandsOn_StarterApp.swift
//  CloudKit-HandsOn-Starter
//
//  Created by Gerson Janhuel on 29/06/22.
//

import SwiftUI

@main
struct CloudKit_HandsOn_StarterApp: App {
    
    @UIApplicationDelegateAdaptor(CustomAppDelegate.self) var appDelegate
    
    // for coredata
    private let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            MyVocabulariesView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

class CustomAppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // receive remote notification payload in UserInfo
        if let category = userInfo["aps"] as? NSDictionary {
            if let categoryName = category["category"] as? String, categoryName == "LatestVocabularies" {
                
                // do something
                NotificationCenter.default.post(name: .vocabsUpdateNotification, object: nil)
            }
        }
    }
}

// custom Notification Name
extension Notification.Name {
    static let vocabsUpdateNotification = Notification.Name("VocabsUpdateNotification")
}
