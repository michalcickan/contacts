import Foundation
import SwiftUI
import Combine

enum SceneRoute {
    case main
    case contacts
    case favouriteContacts
    case addContact
    case contactDetail(_ model: Contact)
}

extension SceneRoute {
    @ViewBuilder
    func view(_ contactsManager: ContactsManager) -> some View {
        switch self {
        case let .contactDetail(model):
            EmptyView()
        case .main:
            EmptyView()
        case .contacts:
            EmptyView()
        case .favouriteContacts:
            EmptyView()
        case .addContact:
            AddContactView(
                viewModel: AddContactViewModel(service: contactsManager)
            )
        }
    }
}

extension SceneRoute: Identifiable {
    var id: String {
        switch self {
        case let .contactDetail(model):
            return model.id.storeIdentifier ?? String(describing: model)
        case .main:
            return "main"
        case .contacts:
            return "contacts"
        case .favouriteContacts:
            return "favouriteContacts"
        case .addContact:
            return "addContact"
        }
    }
}

extension SceneRoute: Hashable {
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

extension SceneRoute: Equatable {
    static func == (lhs: SceneRoute, rhs: SceneRoute) -> Bool {
        lhs.id == rhs.id
    }
}
