import SwiftUI
import SwiftData

struct RoutingView<Content: View>: View {
    @StateObject var router: Router
    private let content: Content
    @Environment(\.modelContext) private var context
    
    init(router: Router, @ViewBuilder content: @escaping () -> Content) {
        _router = StateObject(wrappedValue: router)
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: router.navigationPath) {
            content
                .navigationDestination(for: SceneRoute.self) { sceneRoute in
                    router.configure(view: sceneRoute.view(context), route: .navigation)
                }
        }.sheet(item: router.presentingSheet) { sceneRoute in
            router.configure(
                view: sceneRoute.view(context),
                route: .sheet
            )
        }
    }
}
