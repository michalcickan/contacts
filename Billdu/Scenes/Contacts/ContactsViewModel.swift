import Foundation
import Combine

class ContactsViewModel: ContactsOutput, ContactsInput {
    // MARK: - Output
    @Published private(set) var contacts: [ContactCellViewModel] = []
    let sceneTitle: String
    let _showRoute = PassthroughSubject<SceneRoute, Never>()
    var showRoute: AnyPublisher<SceneRoute, Never> {
        _showRoute.eraseToAnyPublisher()
    }
    
    // MARK: - Input
    @Published var searchText: String = ""
    let didTapAddContact = PassthroughSubject<Void, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    private let isFavouriteMode: Bool
    
    init(isFavouriteMode: Bool, service: ContactsServiceType, contactsObservable: ContactsObservable) {
        self.isFavouriteMode = isFavouriteMode
        self.sceneTitle = isFavouriteMode ? "favourite_contacts_title" : "contacts_title"
        
        
        Publishers.CombineLatest(
            $searchText
                .debounce(for: .milliseconds(300), scheduler: DispatchQueue.global()),
            contactsObservable.contacts
        )
        .asyncMap(searchContacts(service))
        .map(mapContacts)
        .receive(on: RunLoop.main)
        .assign(to: \.contacts, on: self)
        .store(in: &cancellables)
        
        didTapAddContact
            .map { SceneRoute.addContact }
            .sink { [unowned _showRoute] route in _showRoute.send(route) }
            .store(in: &cancellables)
    }
}

private extension ContactsViewModel {
    func searchContacts(_ service: ContactsServiceType) -> (String, [Contact]) async -> [Contact] {
        { query, contacts in
            query.count > 2 ? contacts.searchFulltext(with: query) : contacts
        }
    }
    
    var mapContacts: ([Contact]) -> [ContactCellViewModel] {
        { [unowned _showRoute] contacts in
            contacts.enumerated()
                .map { offset, model in
                    ContactCellViewModel(
                        id: "\(offset)",
                        model: model,
                        swipeActions: self.favouriteSwipeActions
                    ) {
                        _showRoute.send(.contactDetail(model))
                    }
                }
        }
    }
    
    var favouriteSwipeActions: [SwipeActionViewModel] {
        [
            SwipeActionViewModel(style: .addFavourite) {
                
            },
            SwipeActionViewModel(style: .unfavourite) {
                
            }
        ]
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
