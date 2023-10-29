import Foundation
import Combine

final class AddContactViewModel: AddContactInput, AddContactOutput {
    // MARK: - Input
    @Published var name = ""
    @Published var surname = ""
    @Published var phoneNumber = ""
    var didTapConfirm = PassthroughSubject<Void, Never>()
    var sceneTitle: String = "add_contact_title"
    
    // MARK: - Output
    @Published var confirmButtonDisabled: Bool = true
    let close = PassthroughSubject<Void, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(service: AddContactServiceType) {
        Publishers.CombineLatest3($name, $surname, $phoneNumber)
            .map {
                $0.isEmpty || $1.isEmpty || $2.isEmpty
            }
            .assign(to: \.confirmButtonDisabled, on: self)
            .store(in: &cancellables)
        didTapConfirm
            .asyncMap { [unowned self] in
                await service.addContact(
                    name: self.name,
                    surname: self.surname,
                    phoneNumber: self.phoneNumber
                )
            }
            .receive(on: RunLoop.main)
            .sink { [weak close] in
                close?.send(())
            }
            .store(in: &cancellables)
    }
}

extension AddContactViewModel: AddContactViewModelType {
    var input: AddContactInput { get { self } set { } }
    var output: any AddContactOutput { self }
}
