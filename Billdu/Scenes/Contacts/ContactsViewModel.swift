import Foundation
import Combine

class ContactsViewModel: ContactsOutput, ContactsInput {
    // MARK: - Output
    @Published private(set) var contacts: [Contact] = []
    
    // MARK: - Input
    @Published var searchText: String = ""
    let addContact = PassthroughSubject<Void, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    private let service: ContactsServiceType
    
    init(service: ContactsServiceType) {
        self.service = service
        
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.global())
            .flatMap { query in
                Future { promise in
                    Task {
                        do {
                            let contacts = try await service.getAllContacts()
                            promise(.success(contacts.searchFulltext(with: query)))
                        } catch {
                            promise(.success([]))
                        }
                    }
                }
            }
            .receive(on: RunLoop.main)
            .assign(to: \.contacts, on: self)
            .store(in: &cancellables)
    }
}

extension ContactsViewModel {
    
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
