import XCTest
import Combine

@testable import Billdu

final class ContactsViewModelTests: XCTestCase {
    var service = MockContactsService()
    var viewModel: ContactsViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        viewModel = ContactsViewModel(isFavouriteMode: false, service: service, contactsObservable: service)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSearchShouldGiveResultsForValidPhoneNumber() throws {
        let expectedContact = Contact(name: "Michal", surname: "Cickan", phoneNumber: "0949200629")
        service.mockContacts.value = [
            expectedContact,
            Contact(name: "Michal", surname: "Cickan2", phoneNumber: "0905252111")
        ]
        let expectation = XCTestExpectation(description: "State is set to populated")
        self.viewModel.$contacts
            .dropFirst()
            .sink(receiveValue: { value in
                XCTAssertEqual([expectedContact].comparableArray, value.comparableArray)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        viewModel.input.searchText = "0949"
        wait(for: [expectation], timeout: 10)
    }
    
    func testSearchShouldGiveResultsForValidName() throws {
        let expectedContact = Contact(name: "Peter", surname: "Noone", phoneNumber: "0905252111")
        service.mockContacts.value = [
            Contact(name: "Michal", surname: "Cickan", phoneNumber: "0949200629"),
            expectedContact
        ]
        let expectation = XCTestExpectation(description: "State is set to populated")
        self.viewModel.$contacts
            .dropFirst()
            .sink(receiveValue: { value in
                XCTAssertEqual([expectedContact].comparableArray, value.comparableArray)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        viewModel.input.searchText = "Pet"
        wait(for: [expectation], timeout: 10)
    }
    
    func testSearchShouldGiveResultsForValidNameCaseInsensitive() throws {
        let expectedContact = Contact(name: "Peter", surname: "Noone", phoneNumber: "0905252111")
        service.mockContacts.value = [
            Contact(name: "Michal", surname: "Cickan", phoneNumber: "0949200629"),
            expectedContact
        ]
        let expectation = XCTestExpectation(description: "State is set to populated")
        self.viewModel.$contacts
            .dropFirst()
            .sink(receiveValue: { value in
                XCTAssertEqual([expectedContact].comparableArray, value.comparableArray)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        viewModel.input.searchText = "pet"
        wait(for: [expectation], timeout: 10)
    }
    
    func testSearchShouldGiveResultsForValidSurname() throws {
        let expectedContact = Contact(name: "Peter", surname: "Noone", phoneNumber: "0905252111")
        service.mockContacts.value = [
            Contact(name: "Michal", surname: "Cickan", phoneNumber: "0949200629"),
            expectedContact
        ]
        let expectation = XCTestExpectation(description: "State is set to populated")
        self.viewModel.$contacts
            .dropFirst()
            .sink(receiveValue: { value in
                XCTAssertEqual([expectedContact].comparableArray, value.comparableArray)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        viewModel.input.searchText = "Noone"
        wait(for: [expectation], timeout: 10)
    }
    
    func testSearchShouldGiveResultsForValidSurnameCaseInsenstive() throws {
        let expectedContact = Contact(name: "Peter", surname: "Noone", phoneNumber: "0905252111")
        service.mockContacts.value = [
            Contact(name: "Michal", surname: "Cickan", phoneNumber: "0949200629"),
            expectedContact
        ]
        let expectation = XCTestExpectation(description: "State is set to populated")
        self.viewModel.$contacts
            .dropFirst()
            .sink(receiveValue: { value in
                XCTAssertEqual([expectedContact].comparableArray, value.comparableArray)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        viewModel.input.searchText = "Noone"
        wait(for: [expectation], timeout: 10)
    }
    
    func testShouldCallShowRouteWhenDidTapContact() throws {
        let expectation = XCTestExpectation(description: "State is set to populated")
        self.viewModel.showRoute
            .sink(receiveValue: { value in
                XCTAssertEqual(.addContact(isFavouriteMode: true), value)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        viewModel.input.didTapAddContact.send(())
        wait(for: [expectation], timeout: 10)
    }
}

final class MockContactsService: ContactsServiceType, ContactsObservable {
    let mockContacts = CurrentValueSubject<[Billdu.Contact], Never>([])
    var contacts: AnyPublisher<[Contact], Never> { mockContacts.eraseToAnyPublisher() }
    
    func removeContact(contact: Billdu.Contact) {
        
    }
    
    func unfavourite(contact: Billdu.Contact) {
        
    }
    
    func makeFavourite(contact: Billdu.Contact) {
        
    }
}

fileprivate extension Array where Element == ContactCellViewModel {
    var comparableArray: [String] {
        map { $0.title + $0.description }
    }
}

fileprivate extension Array where Element == Contact {
    var comparableArray: [String] {
        map { ContactCellViewModel(model: $0, swipeActions: [], onTap: { }) }
            .map { $0.title + $0.description }
    }
}
