import Foundation

final class Configurator {
    
    func register() {
        ServiceLocator.shared.addServices(service: FetchHelper())
        ServiceLocator.shared.addServices(service: Networking())
        ServiceLocator.shared.addServices(service: DataCaretaker())
    }
}
