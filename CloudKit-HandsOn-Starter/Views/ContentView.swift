//
//  ContentView.swift
//  CloudKit-HandsOn-Starter
//
//  Created by Gerson Janhuel on 29/06/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = VocabViewModel()
    
    var body: some View {
        NavigationView {
            
            List(viewModel.vocabs, id: \.self) { vocab in
               Text(vocab.word)
            }
            .listStyle(InsetListStyle())
            .navigationTitle("Vocabolaries")
            .navigationBarItems(trailing:
                Button(action: {
                    showAlert()
                }, label: {
                    Text("Add")
                })
            )
        }
        .refreshable {
            await viewModel.fetchVocabs()
        }
        .task {
            await viewModel.fetchVocabs()
            
            viewModel.requestNotificationPermission()
            
            await viewModel.subscribeToVocabDatabase()
        }
        .onReceive(NotificationCenter.default.publisher(for: .vocabsUpdateNotification)) { _ in
            Task {
                await viewModel.fetchVocabs()
            }
        }
        
    }
    
    // show alert with TextField
    private func showAlert() {
        let alert = UIAlertController(title: "Add New Vocab", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Type new word"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            let textField = alert.textFields![0] as UITextField
            if let newVocab = textField.text {
                Task {
                    await viewModel.createNewVocab(word: newVocab)
                }
            }
        })
        
        // get root view controller
        let connectedScenes = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }.compactMap { $0 as? UIWindowScene }
        let window = connectedScenes.first?.windows.first { $0.isKeyWindow }
        let rootViewController = window!.rootViewController!
        
        rootViewController.present(alert, animated: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
