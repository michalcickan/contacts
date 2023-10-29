import Foundation
import SwiftData

@Model
final class Contact {
    var name: String
    var surname: String
    var phoneNumber: String
    
    init(name: String,
         surname: String,
         phoneNumber: String) {
        self.name = name
        self.surname = surname
        self.phoneNumber = phoneNumber
    }
}
