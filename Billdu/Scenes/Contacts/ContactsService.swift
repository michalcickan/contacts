import Foundation
import SwiftData

protocol ContactsServiceType {
    func getAllContacts() async throws -> [Contact]
}

struct ContactsService: ContactsServiceType {
    let storage: PersistentStorage
    
    func getAllContacts() async throws -> [Contact] {
        try storage.fetch(
            FetchDescriptor<Contact>()
        )
    }
}
