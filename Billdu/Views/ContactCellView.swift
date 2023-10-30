import Foundation
import SwiftUI

struct ContactCellViewModel: Identifiable, Hashable {
    static func == (lhs: ContactCellViewModel, rhs: ContactCellViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
    
    let id: String
    
    let title: String
    let description: String
    let swipeActions: [SwipeActionViewModel]
    let onTap: () -> Void
    
    init(model: Contact,
         swipeActions: [SwipeActionViewModel],
         onTap: @escaping () -> Void) {
        self.id = model.uuid.uuidString + swipeActions.map { $0.id }.joined(separator: ", ") + model.name + model.surname + model.phoneNumber
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
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.title)
                Text(viewModel.description)
                    .foregroundStyle(Color.black.opacity(0.5))
            }
            Spacer()
        }
        .background(.white)
        .onTapGesture(perform: viewModel.onTap)
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            ForEach(viewModel.swipeActions.leadingActions) { item in
                SwipeAction(viewModel: item)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            ForEach(viewModel.swipeActions.trailingActions) { item in
                SwipeAction(viewModel: item)
            }
        }
    }
}

fileprivate extension Array where Element == SwipeActionViewModel {
    var leadingActions: [SwipeActionViewModel] {
        filter { $0.style == .addFavourite }
    }
    
    var trailingActions: [SwipeActionViewModel] {
        filter {
            switch $0.style {
            case .delete, .unfavourite:
                return true
            default:
                return false
            }
        }
    }
}
