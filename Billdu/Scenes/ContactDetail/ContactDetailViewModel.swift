import Foundation
import Combine

final class ContactDetailViewModel: ContactDetailInput, ContactDetailOutput {
    let didTapAction = PassthroughSubject<Void, Never>()
    
    @Published var name: String
    @Published var surname: String
    @Published var phoneNumber: String
    @Published var isEditMode: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(model: Contact, service: ContactDetailServiceType) {
        name = model.name
        surname = model.surname
        phoneNumber = model.phoneNumber
        
        didTapAction
            .map { [unowned self] in
                guard self.isEditMode else {
                    return
                }
                model.surname = surname
                model.name = name
                model.phoneNumber = phoneNumber
                service.save(contact: model)
            }
            .map { [unowned self] in !self.isEditMode }
            .assign(to: \.isEditMode, on: self)
            .store(in: &cancellables)
    }
}

extension ContactDetailViewModel  {
    
}

extension ContactDetailViewModel: ContactDetailViewModelType {
    var input: ContactDetailInput { get { self } set { } }
    var output: any ContactDetailOutput { self }
}
