import Foundation
import SwiftUI

struct MainScene: View {
    var body: some View {
        TabView {
            ContactsView(viewModel: ContactsViewModel(service: ContactsService()))
        }
    }
}
