import Foundation
import SwiftUI

struct ContactsView<VM: ContactsViewModelType>: View {
    @StateObject private var viewModel: VM
    @EnvironmentObject private var router: Router
    
    init(viewModel: VM) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        RoutingView(router: router) {
            VStack(spacing: 10) {
                
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView(
            viewModel: ContactsViewModel()
        )
    }
}
