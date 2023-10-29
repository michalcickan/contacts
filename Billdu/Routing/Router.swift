import SwiftUI
import Combine

final class Router: ObservableObject {
    enum RouteType {
        case navigation
        case sheet
    }
    
    struct State {
        var navigationPath: [SceneRoute] = []
        var presentingSheet: SceneRoute? = nil
        var isPresented: Binding<SceneRoute?>
        
        var isPresenting: Bool {
            presentingSheet != nil
        }
    }
    
    @Published private(set) var state: State
    
    init(isPresented: Binding<SceneRoute?>) {
        state = State(isPresented: isPresented)
    }
    
    func configure(view: any View, route: RouteType) -> AnyView {
        AnyView(
            view.environmentObject(router(route: route))
        )
    }
}

extension Router {
    func navigateBack() {
        state.navigationPath.removeLast()
    }
    
    func show(_ sceneRoute: SceneRoute, as route: RouteType) {
        switch route {
        case .navigation:
            state.navigationPath.append(sceneRoute)
        case .sheet:
            state.presentingSheet = sceneRoute
        }
    }
    
    func dismiss() {
        if state.presentingSheet != nil {
            state.presentingSheet = nil
        } else if navigationPath.count > 1 {
            state.navigationPath.removeLast()
        } else {
            state.isPresented.wrappedValue = nil
        }
    }
}

extension Router {
    var navigationPath: Binding<[SceneRoute]> {
        binding(keyPath: \.navigationPath)
    }
    
    var presentingSheet: Binding<SceneRoute?> {
        binding(keyPath: \.presentingSheet)
    }
    
    var isPresented: Binding<SceneRoute?> {
        state.isPresented
    }
}

private extension Router {
    func binding<T>(keyPath: WritableKeyPath<State, T>) -> Binding<T> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }
    
    func router(route: RouteType) -> Router {
        switch route {
        case .navigation:
            return self
        case .sheet:
            return Router(isPresented: presentingSheet)
        }
    }
}
