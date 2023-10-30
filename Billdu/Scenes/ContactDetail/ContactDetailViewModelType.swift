import Foundation
import Combine

protocol ContactDetailInput: AnyObject {
    var name: String { get set }
    var surname: String { get set }
    var phoneNumber: String { get set }
    var didTapAction: PassthroughSubject<Void, Never> { get }
}

protocol ContactDetailOutput: ObservableObject {
    var isEditMode: Bool { get }
}

protocol ContactDetailViewModelType: ObservableObject {
    var input: ContactDetailInput { get set }
    var output: any ContactDetailOutput { get }
}
