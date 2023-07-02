import Foundation

struct CategoryFood: Codable {
    let сategories: [CurrentCategory]?
}

// MARK: - СategoryFood
struct CurrentCategory: Codable, Identifiable {
    let id: Int?
    let name: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "image_url"
    }
}
