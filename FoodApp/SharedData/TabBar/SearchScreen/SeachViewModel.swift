import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    
    @Published var hasError: Bool? = false
    @Published var data: [Dish] = []
    @Published var filter: String = ""
    @Published var error: BackendError?
    
    @Injected var fetch: FetchHelper?
    
    //search data
    @Published var searchText: String = ""
    @Published var searchActivated: Bool = false
    @Published var searchedDishes: [Dish]?
    
    var searchCancellable: AnyCancellable?
    
    init() {
        
        fetch?.fetchDishes(completion: { [weak self] in
            
            guard let self = self else { return }
            
            self.hasError = self.fetch?.isErrorDish
            self.error = self.fetch?.errorDish
            self.data = self.fetch?.dishes ?? []
        })
        
        searchCancellable = $searchText.removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                if str != "" {
                    self.filterSubsBySearch()
                } else {
                    self.searchedDishes = nil
                }
            })
    }
    
    func filterSubsBySearch() {
        
        //filtering subs by dish type
        DispatchQueue.global(qos: .userInitiated).async {
            let result = self.data
            
            //since it will require more memory so were using lazy to perform more
                .lazy
                .filter { dish in
                    let currentDish = dish.name ?? String()
                    return currentDish.lowercased().contains(self.searchText.lowercased())
                }
            
            //limiting result
                .prefix(4)
            DispatchQueue.main.async {
                self.searchedDishes = result.compactMap({ dish in
                    return dish
                })
            }
        }
    }
}
