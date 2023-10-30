import Foundation
import SwiftData

protocol ContactsServiceType {
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
        saveChanges()
    }
    
    func unfavourite(contact: Contact) {
        contact.isFavourite = false
        saveChanges()
    }
}
