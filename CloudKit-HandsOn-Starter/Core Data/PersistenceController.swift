//
//  PersistenceController.swift
//  Vocaboo
//
//  Created by Gerson Janhuel on 02/08/21.
//

import Foundation
import CoreData

struct PersistenceController {
    
    // singleton
    static let shared = PersistenceController()
    
    let container: NSPersistentCloudKitContainer = {
        // call the XCDataModel name
        let container = NSPersistentCloudKitContainer(name: "MyVocab")
        
        // make it automatically sync -> dont forget to add remote notification capabilities 
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // load persistent stores
        container.loadPersistentStores { storeDesc, error in
            if let error = error as NSError? {
                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func test() {
        
    }
}
