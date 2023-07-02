import Foundation

final class DataCaretaker {
    
    // MARK: - PROPERTIES
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    // MARK: - Static data caretaker method's for CATEGORIES
    
    private func save<T: Codable>(_ data: [T], key: String) {
        do {
            let encodedData = try self.encoder.encode(data)
            UserDefaults.standard.set(encodedData, forKey: key)
        } catch {
            debugPrint(String(describing: error))
        }
    }
    
    private func load<T: Codable>(key: String) -> [T]? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        
        do {
            let data = try self.decoder.decode([T].self, from: data)
            return data
        } catch {
            debugPrint(String(describing: error))
            return nil
        }
    }
}

extension DataCaretaker {
    
    func saveCategories(data: [CurrentCategory]) {
        save(data, key: Constant.categoriesKey)
    }
    
    func loadCategories() -> [CurrentCategory]? {
        load(key: Constant.categoriesKey)
    }
    
    func saveDishes(data: [Dish]) {
        save(data, key: Constant.dishKey)
    }
    
    func loadDishes() -> [Dish]? {
        load(key: Constant.dishKey)
    }
}

// MARK: - Constant's

extension DataCaretaker {
    enum Constant {
        static let categoriesKey = "Categories"
        static let dishKey = "Dishes"
    }
}
