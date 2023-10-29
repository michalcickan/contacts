import Foundation
import SwiftUI

struct MainScene: View {
    @Environment(\.modelContext) private var context
    
    var body: some View {
        TabView {
            ContactsView(
                viewModel: ContactsViewModel(service: ContactsService(storage: context))
            )
        }
    }
}
