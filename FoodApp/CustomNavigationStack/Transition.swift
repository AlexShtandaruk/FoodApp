import SwiftUI

public enum Transition {
    case none
    case custom(AnyTransition)
}

public enum NavigationType {
    case push
    case pop
    case popToRoot
}
