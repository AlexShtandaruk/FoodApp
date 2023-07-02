import Foundation

final class SharedDataModel: ObservableObject {
 
    //detail category data
    @Published var detailCategory: CurrentCategory?
    @Published var showCategory: Bool = false
    
    //detail dish data
    @Published var detailDish: Dish?
    @Published var showDetailDish: Bool = false
    
    //liked dish
    @Published var likedDish: [Dish] = []
    
    //dish added to cart
    @Published var cartDishes: [Dish] = []
    
    //matched geometry effect from search page
    @Published var fromSearchPage: Bool = false
    
    //calculating total price
    func getTotalPrice() -> String {
        var total: Int = 0
        
        cartDishes.forEach { dish in
            let price = dish.price ?? Int()
            let quantity = dish.quantity
            let totalPrice = quantity * price
            total += totalPrice
        }
        return "\(total)"
    }
}
