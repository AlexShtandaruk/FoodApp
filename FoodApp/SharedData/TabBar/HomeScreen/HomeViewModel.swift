import Foundation

 final class HomeViewModel: ObservableObject {

    @Published var hasError: Bool? = false
    @Published var data: [CurrentCategory]?
    @Published var filter: String = ""
    @Published var error: BackendError?
    
    @Injected var fetch: FetchHelper?

    init() {
        
        fetch?.fetchCategories(completion: { [weak self] in
            
            guard let self = self else { return }
            
            self.hasError = self.fetch?.isErrorCategory
            self.error = self.fetch?.errorCategory
            self.data = self.fetch?.categories
        })
    }
}
 
