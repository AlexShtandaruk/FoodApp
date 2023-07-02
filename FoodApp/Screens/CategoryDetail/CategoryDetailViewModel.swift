import Foundation

final class CategoryDetailViewModel: ObservableObject {
    
    @Published var hasError: Bool? = false
    @Published var data: [Dish] = []
    @Published var error: BackendError?
    
    @Published var selectedTab: DishTeg = .all
    
    @Injected var fetch: FetchHelper?
    
    var filtredData: [Dish] {
        switch selectedTab {
        case .all:
            return data
        default:
            return data.filter {
                $0.tegs?.contains(selectedTab) == true
            }
        }
    }

    init() {
        fetch?.fetchDishes(completion: { [weak self] in
            
            guard let self = self else { return }
            
            self.hasError = self.fetch?.isErrorDish
            self.error = self.fetch?.errorDish
            self.data = self.fetch?.dishes ?? []
        })
    }
     
     
}
 
