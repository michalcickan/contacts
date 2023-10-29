import Foundation
import Combine

protocol ContactsInput: AnyObject {
    var searchText: String { get set }
    var didAppear: PassthroughSubject<Void, Never> { get }
    var didTapAddContact: PassthroughSubject<Void, Never> { get }
}

protocol ContactsOutput: ObservableObject {
    var contacts: [ContactCellViewModel] { get }
    var showRoute: AnyPublisher<SceneRoute, Never> { get }
}

protocol ContactsViewModelType: ObservableObject {
    var input: ContactsInput { get set }
    var output: any ContactsOutput { get }
}
