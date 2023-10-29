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
    
    init(isFavouriteMode: Bool, service: ContactsServiceType, contactsObservable: ContactsObservable) {
        self.sceneTitle = isFavouriteMode ? "favourite_contacts_title" : "contacts_title"
        
        Publishers.CombineLatest(
            $searchText
                .debounce(for: .milliseconds(300), scheduler: DispatchQueue.global()),
            contactsObservable.contacts
                .map {
                    isFavouriteMode ? $0.filter { $0.isFavourite } : $0
                }
                .map { contacts in
                    contacts.sorted(by: { $0.createdAt < $1.createdAt })
                }
                .removeDuplicates()
        )
        .asyncMap(searchContacts())
        .map(mapContacts(isFavouriteMode: isFavouriteMode, service: service))
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
    func searchContacts() -> (String, [Contact]) async -> [Contact] {
        { query, contacts in
            query.count > 2 ? contacts.searchFulltext(with: query) : contacts
        }
    }
    
    func mapContacts(isFavouriteMode: Bool, service: ContactsServiceType) -> ([Contact]) -> [ContactCellViewModel] {
        { [unowned self] contacts in
            contacts.enumerated()
                .map { offset, model in
                    ContactCellViewModel(
                        id: "\(offset)",
                        model: model,
                        swipeActions: isFavouriteMode ? model.favouriteSwipeActions(service: service) : model.normalSwipeActions(service: service)
                    ) {
                        self._showRoute.send(.contactDetail(model))
                    }
                }
        }
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

fileprivate extension Contact {
    func favouriteSwipeActions(service: ContactsServiceType) -> [SwipeActionViewModel] {
        [
            SwipeActionViewModel(style: .unfavourite) { [unowned self] in
                service.unfavourite(contact: self)
            }
        ]
    }
    
    func normalSwipeActions(service: ContactsServiceType) -> [SwipeActionViewModel] {
        [
            SwipeActionViewModel(style: isFavourite ? .unfavourite : .addFavourite) { [unowned self] in
                self.isFavourite ? service.unfavourite(contact: self) : service.makeFavourite(contact: self)
            },
            SwipeActionViewModel(style: .delete) { [unowned self] in
                service.removeContact(contact: self)
            }
        ]
    }
}
