import Foundation
import Combine

protocol ContactsInput: AnyObject {
    var searchText: String { get set }
    var addContact: PassthroughSubject<Void, Never> { get }
}

protocol ContactsOutput: ObservableObject {
    var contacts: [Contact] { get }
}

protocol ContactsViewModelType: ObservableObject {
    var input: ContactsInput { get set }
    var output: any ContactsOutput { get }
}
