import Foundation
import Combine

protocol AddContactInput: AnyObject {
    var name: String { get set }
    var surname: String { get set }
    var phoneNumber: String { get set }
    var didTapConfirm: PassthroughSubject<Void, Never> { get }
}

protocol AddContactOutput: ObservableObject {
    var sceneTitle: String { get }
    var confirmButtonDisabled: Bool { get }
    var close: PassthroughSubject<Void, Never> { get }
}

protocol AddContactViewModelType: ObservableObject {
    var input: AddContactInput { get set }
    var output: any AddContactOutput { get }
}
