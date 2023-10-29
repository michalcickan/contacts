import Foundation
import SwiftUI

struct MainScene: View {
    @Environment(\.modelContext) private var context
    
    var body: some View {
        TabView {
            ContactsView(
                viewModel: ContactsViewModel(isFavouriteMode: false, service: ContactsService(storage: context))
            )
            .tabItem {
                Image(systemName: "person.circle.fill")
            }
            ContactsView(
                viewModel: ContactsViewModel(isFavouriteMode: true, service: ContactsService(storage: context))
            )
            .tabItem {
                Image(systemName: "star")
            }
        }
    }
}
