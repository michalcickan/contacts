import SwiftUI


struct SwipeActionViewModel: Equatable, Hashable, Identifiable {
    var id: String {
        String(describing: self)
    }
    
    static func == (lhs: SwipeActionViewModel, rhs: SwipeActionViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
    
    enum Style {
        case delete, addFavourite
    }
    
    let title: String
    let action: () -> Void
    let style: Style
}

struct SwipeAction: View {
    let viewModel: SwipeActionViewModel
    
    init(viewModel: SwipeActionViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Button(
            viewModel.title,
            action: viewModel.action
        )
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
        }
    }
}

#Preview {
    SwipeAction(viewModel: SwipeActionViewModel(title: "test", action: { }, style: .addFavourite))
}
