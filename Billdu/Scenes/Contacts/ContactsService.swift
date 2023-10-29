import Foundation
import SwiftData

protocol ContactsServiceType {
    func getAllContacts() async throws -> [Contact]
    func removeContact(contact: Contact)
    func unfavourite(contact: Contact)
    func makeFavourite(contact: Contact)
}

extension ContactsManager: ContactsServiceType {
    func removeContact(contact: Contact) {
        delete(contact: contact)
    }
    
    func makeFavourite(contact: Contact) {
        contact.isFavourite = true
        notifyAboutChange()
    }
    
    func unfavourite(contact: Contact) {
        contact.isFavourite = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.notifyAboutChange()
        }
    }
    
    func getAllContacts() async throws -> [Contact] {
        try persistentStorage.fetch(
            FetchDescriptor<Contact>()
        )
    }
}
