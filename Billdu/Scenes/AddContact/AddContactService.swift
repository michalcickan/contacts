import Foundation

protocol AddContactServiceType {
    func addContact(_ contact: Contact) async
}

extension ContactsManager: AddContactServiceType {
    func addContact(_ contact: Contact) async {
        insert(contact: contact)
    }
}
