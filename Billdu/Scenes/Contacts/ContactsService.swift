import Foundation
import SwiftData

protocol ContactsServiceType {
    func getAllContacts() async throws -> [Contact]
}

extension ContactsManager: ContactsServiceType {
    func getAllContacts() async throws -> [Contact] {
        try persistentStorage.fetch(
            FetchDescriptor<Contact>()
        )
    }
}
