import Foundation
import Combine

protocol ContactsInput: AnyObject {
    
}

protocol ContactsOutput: ObservableObject {
    
}

protocol ContactsViewModelType: ObservableObject {
    var input: ContactsInput { get set }
    var output: any ContactsOutput { get }
}
