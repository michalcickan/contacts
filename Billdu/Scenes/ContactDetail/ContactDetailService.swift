import Foundation

protocol ContactDetailServiceType {
    func save(contact: Contact)
}

extension ContactsManager: ContactDetailServiceType {
    func save(contact: Contact) {
        insert(contact: contact)
    }
}
