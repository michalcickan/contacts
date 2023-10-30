import Foundation
import SwiftUI

struct AddContactView<VM: AddContactViewModelType>: View {
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
                        TextField("surname_placeholder", text: $viewModel.input.surname)
                            .textFieldStyle(.roundedBorder)
                        TextField("phone_placeholder", text: $viewModel.input.phoneNumber)
                            .keyboardType(.phonePad)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding()
                }
                Button("Confirm") {
                    viewModel.input.didTapConfirm.send(())
                }
                .disabled(viewModel.output.confirmButtonDisabled)
            }
            .onReceive(viewModel.output.close) {
                router.dismiss()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(LocalizedStringKey(viewModel.output.sceneTitle))
        }
    }
}

//struct AddContactView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddContactView(
//            viewModel: AddContactViewModel(service: AddContactService())
//        )
//        .environmentObject(Router(isPresented: .constant(.contacts)))
//    }
//}
