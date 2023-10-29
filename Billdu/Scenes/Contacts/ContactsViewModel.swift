import Foundation

class ContactsViewModel: ContactsInput {
    init(service: ContactsServiceType = ContactsService()) {
        
    }
}

extension ContactsViewModel: ContactsOutput {
    
}

extension ContactsViewModel: ContactsViewModelType {
    var input: ContactsInput { get { self } set {  } }
    var output: any ContactsOutput { self }
}
