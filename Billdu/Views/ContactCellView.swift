import Foundation
import SwiftUI

struct ContactCellViewModel: Identifiable {
    let id: String
    
    let title: String
    let description: String
    let swipeActions: [SwipeActionViewModel]
    let onTap: () -> Void
    
    init(id: String, 
         model: Contact,
         swipeActions: [SwipeActionViewModel],
         onTap: @escaping () -> Void) {
        self.id = id
        self.title = "\(model.name) \(model.surname)"
        self.description = model.phoneNumber
        self.swipeActions = swipeActions
        self.onTap = onTap
    }
}

struct ContactCellView: View {
    var viewModel: ContactCellViewModel
    
    init(viewModel: ContactCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text(viewModel.title)
            Text(viewModel.description)
                .foregroundStyle(Color.black.opacity(0.5))
        }
        .swipeActions {
            ForEach(viewModel.swipeActions) { item in
                SwipeAction(viewModel: item)
            }
        }
        .onTapGesture(perform: viewModel.onTap)
    }
}
