import SwiftUI


struct SwipeActionViewModel: Equatable, Hashable, Identifiable {
    static func == (lhs: SwipeActionViewModel, rhs: SwipeActionViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
    
    enum Style {
        case delete, addFavourite, unfavourite
    }
    
    let style: Style
    let id: String
    let action: () -> Void
    
    init(style: SwipeActionViewModel.Style, id: String, action: @escaping () -> Void) {
        self.style = style
        self.id = "\(id) \(style.hashValue)"
        self.action = action
    }
}

struct SwipeAction: View {
    let viewModel: SwipeActionViewModel
    
    init(viewModel: SwipeActionViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Button(
            action: viewModel.action
        ) {
            Image(systemName: viewModel.style.systemImageName)
        }
        .tint(viewModel.style.tintColor)
    }
}

fileprivate extension SwipeActionViewModel.Style {
    var tintColor: Color {
        switch self {
        case .addFavourite:
            return .yellow
        case .delete:
            return .red
        case .unfavourite:
            return .red
        }
    }
    
    var systemImageName: String {
        switch self {
        case .addFavourite:
            return "star"
        case .delete:
            return "trash"
        case .unfavourite:
            return "star.slash"
        }
    }
}

#Preview {
    SwipeAction(viewModel: SwipeActionViewModel(style: .addFavourite, id: "") { })
}
