import Foundation

protocol AddContactServiceType {
    func addContact(name: String, surname: String, phoneNumber: String) async
}

extension ContactsManager: AddContactServiceType {
    func addContact(name: String, surname: String, phoneNumber: String) async {
        insert(
            contact: Contact(name: name, surname: surname, phoneNumber: phoneNumber)
        )
    }
}
