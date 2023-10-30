import Foundation
import SwiftUI

struct ContactDetailView<VM: ContactDetailViewModelType>: View {
    @StateObject private var viewModel: VM
    @EnvironmentObject private var router: Router
    
    init(viewModel: VM) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        RoutingView(router: router) {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        TextField("name_placeholder", text: $viewModel.input.name)
                            .textFieldStyle(.roundedBorder)
                            .disabled(!viewModel.output.isEditMode)
                        TextField("surname_placeholder", text: $viewModel.input.surname)
                            .textFieldStyle(.roundedBorder)
                            .disabled(!viewModel.output.isEditMode)
                        TextField("phone_placeholder", text: $viewModel.input.phoneNumber)
                            .keyboardType(.phonePad)
                            .textFieldStyle(.roundedBorder)
                            .disabled(!viewModel.output.isEditMode)
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: router.dismiss) {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(viewModel.output.isEditMode ? "Done" : "Edit") {
                        viewModel.input.didTapAction.send(())
                    }
                }
            }
            .navigationTitle("Detail")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContactDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetailView(
            viewModel: ContactDetailViewModel(model: Contact(name: "", surname: "", phoneNumber: ""), service: ContactsManager(persistentStorage: PreviewStorage()))
        )
        .environmentObject(Router(isPresented: .constant(.contacts)))
    }
}
