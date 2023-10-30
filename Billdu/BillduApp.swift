//
//  BillduApp.swift
//  Billdu
//
//  Created by Michal Cickan on 27/10/2023.
//

import SwiftUI
import SwiftData

@main
struct BillduApp: App {
    var modelContainer: ModelContainer = {
        let schema = Schema([
            Contact.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainScene()
                .environmentObject(Router(isPresented: .constant(.main)))
                .environmentObject(ContactsManager(persistentStorage: modelContainer.mainContext))
        }
    }
}
