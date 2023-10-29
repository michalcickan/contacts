import Foundation
import Combine

class ContactsViewModel: ContactsOutput, ContactsInput {
    // MARK: - Output
    @Published private(set) var contacts: [ContactCellViewModel] = []
    
    // MARK: - Input
    @Published var searchText: String = ""
    let didTapAddContact = PassthroughSubject<Void, Never>()
    let didAppear = PassthroughSubject<Void, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    private let service: ContactsServiceType
    
    let _showRoute = PassthroughSubject<SceneRoute, Never>()
    var showRoute: AnyPublisher<SceneRoute, Never> {
        _showRoute.eraseToAnyPublisher()
    }
    
    var _showError = PassthroughSubject<String, Never>()
    var showError: AnyPublisher<String, Never> {
        _showError.eraseToAnyPublisher()
    }
    
    init(service: ContactsServiceType) {
        self.service = service
        
        Publishers.Merge(
            $searchText
                .dropFirst()
                .debounce(for: .milliseconds(300), scheduler: DispatchQueue.global())
                .asyncMap { [weak _showError] query in
                    do {
                        let contacts = try await service.getAllContacts()
                        return contacts.searchFulltext(with: query)
                    } catch {
                        _showError?.send(error.localizedDescription)
                        return []
                    }
                },
            didAppear
                .asyncMap { [weak _showError] in
                    do {
                        return try await service.getAllContacts()
                    } catch {
                        _showError?.send(error.localizedDescription)
                        return []
                    }
                }
        )
        .map { [unowned _showRoute] contacts in
            contacts.enumerated()
                .map { offset, model in
                    ContactCellViewModel(
                        id: "\(offset)",
                        model: model,
                        swipeActions: []
                    ) {
                        _showRoute.send(.contactDetail(model))
                    }
                }
        }
        .receive(on: RunLoop.main)
        .assign(to: \.contacts, on: self)
        .store(in: &cancellables)
        didTapAddContact
            .map { SceneRoute.addContact }
            .sink { [unowned _showRoute] route in _showRoute.send(route) }
            .store(in: &cancellables)
    }
}

extension ContactsViewModel: ContactsViewModelType {
    var input: ContactsInput { get { self } set {  } }
    var output: any ContactsOutput { self }
}

fileprivate extension Array where Element == Contact {
    func searchFulltext(with query: String) -> [Element] {
        let normalizedQuery = query.lowercased()
        return filter {
            $0.phoneNumber.lowercased().contains(normalizedQuery) ||
            $0.name.lowercased().lowercased().contains(normalizedQuery) ||
            $0.surname.lowercased().contains(normalizedQuery)
        }
    }
}
