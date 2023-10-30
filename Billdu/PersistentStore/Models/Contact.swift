import Foundation
import SwiftData

@Model
final class Contact {
    var uuid: UUID
    var name: String
    var surname: String
    var phoneNumber: String
    var isFavourite: Bool
    var createdAt: TimeInterval
    
    init(name: String,
         surname: String,
         phoneNumber: String,
         isFavourite: Bool = false,
         createdAt: Date = Date()) {
        self.name = name
        self.surname = surname
        self.phoneNumber = phoneNumber
        self.isFavourite = isFavourite
        self.createdAt = createdAt.timeIntervalSince1970
        self.uuid = UUID()
    }
}
