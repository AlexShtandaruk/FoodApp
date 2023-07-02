import Foundation

final class FetchHelper {
    
    //categories
    @Published var isErrorCategory = false
    @Published var categories: [CurrentCategory]?
    @Published var errorCategory: BackendError?
    
    //dishes
    @Published var isErrorDish = false
    @Published var dishes: [Dish]?
    @Published var errorDish: BackendError?
    
    //property wrapped
    @Injected var network: Networking?
    @Injected var storage: DataCaretaker?
    
    
    //method categories
    func fetchCategories(completion: @escaping () -> Void) {
        
        network?.getCategoryData { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let model):
                self.categories = model?.сategories
                self.storage?.saveCategories(data: model?.сategories ?? [])
                
            case .failure(let error):
                self.isErrorCategory = true
                self.errorCategory = error
                self.categories = self.storage?.loadCategories()
            }
            
            completion()
        }
    }
    
    //method dishes
    func fetchDishes(completion: @escaping () -> Void) {
        
        network?.getDishData { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let model):
                self.dishes = model?.dishes
                self.storage?.saveDishes(data: model?.dishes ?? [])
                
            case .failure(let error):
                self.isErrorDish = true
                self.errorDish = error
                self.dishes = self.storage?.loadDishes()
            }
            
            completion()
        }
        
    }
}
