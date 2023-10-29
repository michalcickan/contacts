import Foundation
import SwiftData

@Model
final class Contact {
    var name: String
    var surname: String
    var phoneNumber: String
    var isFavourite: Bool
    
    init(name: String,
         surname: String,
         phoneNumber: String,
         isFavourite: Bool = false) {
        self.name = name
        self.surname = surname
        self.phoneNumber = phoneNumber
        self.isFavourite = isFavourite
    }
}
