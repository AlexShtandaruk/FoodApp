import SwiftUI

struct NavigationContainerView<Content: View>: View {

    @ObservedObject var viewModel: NavigationContainerViewModel = .init()
    private var content: Content
    
    private let animation: Animation = .easeIn(duration: 0.5)
    private let transition: (push: AnyTransition, pop: AnyTransition)
    
    init(transition: Transition, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        switch transition {
        case .custom(let anyTransition):
            self.transition = (anyTransition, anyTransition)
        case .none:
            self.transition = (.identity, .identity)
        }
    }
    var body: some View {
        let isRoot = viewModel.currentScreen == nil
        return ZStack {
            if isRoot {
                self.content.environmentObject(self.viewModel)
                    .animation(animation)
                    .transition(viewModel.navigationType == .push ? transition.push : transition.pop)
            } else {
                viewModel.currentScreen?.view.environmentObject(self.viewModel)
                    .animation(animation)
                    .transition(viewModel.navigationType == .push ? transition.push : transition.pop)
            }
        }
    }
}
