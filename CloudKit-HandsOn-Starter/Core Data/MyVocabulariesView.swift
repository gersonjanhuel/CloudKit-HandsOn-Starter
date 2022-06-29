//
//  MyVocabulariesView.swift
//  Vocaboo
//
//  Created by Gerson Janhuel on 02/08/21.
//

import SwiftUI
import CoreData

struct MyVocabulariesView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // fetched data with FetchRequest property wrapper 
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \MyVocab.addedAt, ascending: true)], animation: .default)
    private var myVocabularies: FetchedResults<MyVocab>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(myVocabularies) { vocab in
                    Text(vocab.word ?? "-")
                }
                .onDelete(perform: { indexSet in
                    //myVocabularies.remove(atOffsets: indexSet)
                    deleteVocab(at: indexSet)
                })
                
            }
            .listStyle(PlainListStyle())
            .navigationTitle("My Vocabularies")
            .navigationBarItems(trailing:
                Button(action: {
                    showAlert()
                }, label: {
                    Text("Add")
                })
            )
        }
    }
    
    // show alert with TextField
    private func showAlert() {
        // create new alert
        let alert = UIAlertController(title: "Add", message: nil, preferredStyle: .alert)
        
        // add text field
        alert.addTextField { (textField) in
            textField.placeholder = "Type new word"
        }
        
        // add Cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // add Save button
        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            let textField = alert.textFields![0] as UITextField
            if let newVocab = textField.text {
                saveNewVocab(word: newVocab)
            }
        })
        
        // get root view controller
        let connectedScenes = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }.compactMap { $0 as? UIWindowScene }
        let window = connectedScenes.first?.windows.first { $0.isKeyWindow }
        let rootViewController = window!.rootViewController!
        
        rootViewController.present(alert, animated: true)
    }   
    
    // CORE DATA - save new vocab
    private func saveNewVocab(word: String) {
        let newVocab = MyVocab(context: viewContext)
        newVocab.word = word
        newVocab.addedAt = Date()
        
        do {
            try viewContext.save()
        } catch {
            print("Error on saving: \(error)")
        }
    }
    
    //CORE DATA - delete vocab
    private func deleteVocab(at index: IndexSet) {
        index.map { myVocabularies[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            print("Error on delete: \(error)")
        }
    }
}

struct MyVocabulariesView_Previews: PreviewProvider {
    static var previews: some View {
        MyVocabulariesView()
    }
}
