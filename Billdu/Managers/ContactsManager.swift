import Foundation
import SwiftData
import Combine

protocol ContactsObservable {
    var contacts: AnyPublisher<[Contact], Never> { get }
}

protocol ContactsOperations {
    func insert(contact: Contact)
    func delete(contact: Contact)
}

final class ContactsManager: ObservableObject {
    let persistentStorage: PersistentStorage
    let _contacts: CurrentValueSubject<[Contact], Never> = CurrentValueSubject([])
    
    init(persistentStorage: PersistentStorage) {
        self.persistentStorage = persistentStorage
        notifyAboutChange()
    }
}

extension ContactsManager: ContactsOperations {
    func insert(contact: Contact) {
        persistentStorage.insert(contact)
        notifyAboutChange()
    }
    
    func delete(contact: Contact) {
        persistentStorage.delete(contact)
        notifyAboutChange()
    }
}

extension ContactsManager: ContactsObservable {
    var contacts: AnyPublisher<[Contact], Never> {
        _contacts.eraseToAnyPublisher()
    }
}

extension ContactsManager {
    func notifyAboutChange() {
        guard let contacts = try? self.persistentStorage.fetch(FetchDescriptor<Contact>()) else {
            return
        }
        self._contacts.send(contacts)
    }
}

