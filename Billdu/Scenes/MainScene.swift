import Foundation
import SwiftUI

struct MainScene: View {
    @EnvironmentObject var contactsManager: ContactsManager
    
    var body: some View {
        TabView {
            ContactsView(
                viewModel: ContactsViewModel(
                    isFavouriteMode: false,
                    service: contactsManager,
                    contactsObservable: contactsManager
                )
            )
            .tabItem {
                Image(systemName: "person.circle.fill")
            }
            ContactsView(
                viewModel: ContactsViewModel(
                    isFavouriteMode: true,
                    service: contactsManager,
                    contactsObservable: contactsManager
                )
            )
            .tabItem {
                Image(systemName: "star")
            }
        }
    }
}
