//
//  CloudKitService.swift
//  CloudKit-Basic-Test
//
//  Created by Gerson Janhuel on 28/06/22.
//

import Foundation
import CloudKit

class CloudKitService {
    
    private let database: CKDatabase = CKContainer(identifier: "YOUR-CONTAINER-ID").publicCloudDatabase
    
    // save record to cloudkit
    func save(_ record: CKRecord) {
        // do something
    }
    
    // fetching records with query
    func fetchRecords(recordType: String, predicate: NSPredicate) -> [CKRecord] {
        // do something
        return [CKRecord]()
    }
    
    // subscribe to database
    func subscribeToDatabase(recordType: String) {
        // do something
    }
}
