//
//  VocabViewModel.swift
//  CloudKit-HandsOn-Starter
//
//  Created by Gerson Janhuel on 29/06/22.
//

import Foundation
import UserNotifications
import SwiftUI

struct Vocab: Hashable {
    var word: String
}


class VocabViewModel: ObservableObject {
    
    //private let cloudKitService = CloudKitService()
    
    @Published var vocabs: [Vocab] = []
    
    
    func createNewVocab(word: String) {
        // do something here
    }
    
    func fetchVocabs() {
        // do something here
    }
    
    func subscribeToVocabDatabase() {
        // do something here
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

