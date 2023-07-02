import Foundation

struct Dishes: Codable {
    let dishes: [Dish]?
}

// MARK: - Dish
struct Dish: Codable, Identifiable, Hashable {
    let id: Int?
    let name: String?
    let price, weight: Int?
    let description: String?
    let imageURL: String?
    let tegs: [DishTeg]?
    var quantity: Int = 1

    enum CodingKeys: String, CodingKey {
        case id, name, price, weight, description
        case imageURL = "image_url"
        case tegs
    }
}

enum DishTeg: String, Codable, CaseIterable {
    case all = "Все меню"
    case rice = "С рисом"
    case fish = "С рыбой"
    case salad = "Салаты"
}
