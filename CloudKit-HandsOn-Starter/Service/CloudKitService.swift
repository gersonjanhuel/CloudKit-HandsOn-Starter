//
//  CloudKitService.swift
//  CloudKit-Basic-Test
//
//  Created by Gerson Janhuel on 28/06/22.
//

import Foundation
import CloudKit

class CloudKitService {
    
    private let database: CKDatabase = CKContainer(identifier: "iCloud.cloudkit.handson.morning").publicCloudDatabase
    
    // save record to cloudkit
    func save(_ record: CKRecord) async throws {
        do {
            let savedRecord = try await database.save(record)
            print(savedRecord)
            print("\(savedRecord["word"] as! String) successfully saved to iCloud")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // fetching records with query
    func fetchRecords(recordType: String, predicate: NSPredicate) async throws -> [CKRecord] {
        
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        let result = try await database.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        
        return records
    }
    
    // subscribe to database
    func subscribeToDatabase(recordType: String) async {
        
        // prepare subscription ID
        let subscriptionID = "latest-\(recordType)"
        
        // create subscription object
        let subscription = CKQuerySubscription(recordType: recordType, predicate: NSPredicate(value: true), subscriptionID: subscriptionID, options: [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion])
        
        // setup push notification
        let notification = CKSubscription.NotificationInfo()
        notification.title = "New vocab updated!"
        notification.alertBody = "Please open the app to checkout!"
        notification.soundName = "default"
        notification.category = "Latest\(recordType)"
        notification.shouldSendContentAvailable = true
        
        subscription.notificationInfo = notification
        
        do {
            let successSub = await try database.save(subscription)
            print("Subscription success with id \(successSub.subscriptionID)")
        } catch {
            print(error.localizedDescription)
        }
    }
}
