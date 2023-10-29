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
            List(viewModel.output.contacts) { item in
                ContactCellView(viewModel: item)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(LocalizedStringKey(viewModel.output.sceneTitle))
            .toolbar {
                Button {
                    viewModel.input.didTapAddContact.send(())
                } label: {
                    Image(systemName: "plus")
                }
            }
            .onReceive(viewModel.output.showRoute) {
                router.show($0, as: .sheet)
            }
            .searchable(text: $viewModel.input.searchText)
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView(
            viewModel: ContactsViewModel(isFavouriteMode: false, service: ContactsManager(persistentStorage: PreviewStorage()), contactsObservable: ContactsManager(persistentStorage: PreviewStorage())
        ))
        .environmentObject(Router(isPresented: .constant(.contacts)))
    }
}
