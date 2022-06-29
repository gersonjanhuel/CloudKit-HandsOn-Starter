//
//  VocabViewModel.swift
//  CloudKit-HandsOn-Starter
//
//  Created by Gerson Janhuel on 29/06/22.
//

import Foundation
import SwiftUI
import CloudKit
import UserNotifications

struct Vocab: Hashable {
    var word: String
}

extension Vocab {
    static let recordType = "Vocabularies"
    
    var record: CKRecord {
        let record = CKRecord(recordType: Vocab.recordType)
        record["word"] = word
        return record
    }
}



class VocabViewModel: ObservableObject {
    
    private let cloudKitService = CloudKitService()
    
    @Published var vocabs: [Vocab] = []
    
    
    func createNewVocab(word: String) async {
        // transform word -> Vocab -> CKRecord
        let newVocab = Vocab(word: word)
        let ckrecord = newVocab.record
        
        do {
            try await cloudKitService.save(ckrecord)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchVocabs() async {
        
        do {
            let records = try await cloudKitService.fetchRecords(recordType: Vocab.recordType, predicate: NSPredicate(value: true))
            
            DispatchQueue.main.async {
                // transform CKRecord into Vocab data model
                let vocabsRaw = records.compactMap { Vocab(word: $0["word"] as! String) }
                
                // sort by word ascending
                self.vocabs = vocabsRaw.sorted(by: { a, b in
                    return a.word < b.word
                })
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func subscribeToVocabDatabase() async {
        await cloudKitService.subscribeToDatabase(recordType: Vocab.recordType)
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                //application.registerForRemoteNotifications()
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
            }
        }
    }
    
    
}

