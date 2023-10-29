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
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(LocalizedStringKey(viewModel.output.sceneTitle))
            .toolbar {
                Button {
                    print("Edit button was tapped")
                } label: {
                    Image(systemName: "plus")
                }
            }
            .onAppear {
                viewModel.input.didAppear.send(())
            }
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView(
            viewModel: ContactsViewModel(isFavouriteMode: false, service: ContactsService(storage: PreviewStorage()))
        )
        .environmentObject(Router(isPresented: .constant(.contacts)))
    }
}
