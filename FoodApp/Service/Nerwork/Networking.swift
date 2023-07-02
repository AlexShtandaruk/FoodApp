import UIKit

final class Networking {
    
    private var casheImage = NSCache<NSString, UIImage>()
    
    private func getDataFromUrl<T: Codable>(url: URL, completion: @escaping BackendOperationHandler<T>) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.decodeError(description: error?.localizedDescription)))
                }
                return
            }
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.decodeError(description: Constant.response.localized())))
                }
                return
            }
            DispatchQueue.main.async {
                
                switch StatusCode.returnResult(for: response.statusCode) {
                    
                case .information:
                    completion(.failure(.information(description: Constant.information.localized(), statusCode: response.statusCode)))
                case .resursive:
                    completion(.failure(.redirection(description: Constant.recursive.localized(), statusCode: response.statusCode)))
                case .authError:
                    completion(.failure(.authError(description: Constant.authError.localized(), statusCode: response.statusCode)))
                case .clientError:
                    completion(.failure(.clientError(description: Constant.clientError.localized(), statusCode: response.statusCode)))
                case .serverError:
                    completion(.failure(.serverError(description: Constant.serverError.localized(), statusCode: response.statusCode)))
                case .success:
                    guard let data = data else {
                        completion(.failure(.unresolved(description: Constant.guardData.localized(), statusCode: response.statusCode)))
                        return
                    }
                    do {
                        let model = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(model))
                    }
                    catch {
                        completion(.failure(.decodeError(description: Constant.catchData.localized())))
                    }
                }
            }
        }.resume()
    }
    
    func fetchImageData(from url: URL, completion: @escaping (UIImage) -> Void) {
        
        if let cashedImage = casheImage.object(forKey: url.absoluteString as NSString) {
            completion(cashedImage)
        }
        
        let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let mimeType = response.mimeType,
                mimeType.hasPrefix("image"),
                let data = data,
                error == nil,
                let image = UIImage(data: data)
            else {
                return
            }
            self.casheImage.setObject(image, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}

// MARK: - Get movie data from url

extension Networking {
    
    func getCategoryData(competion: @escaping BackendOperationHandler<CategoryFood>) {
        getDataFromUrl(url: EndPoint.getCategoryUrl(), completion: competion)
    }
    
    func getDishData(competion: @escaping BackendOperationHandler<Dishes>) {
        getDataFromUrl(url: EndPoint.getDishUrl(), completion: competion)
    }
}

// MARK: - Constant's

extension Networking {
    struct Constant {
        static let guardData = "networking.guardData"
        static let catchData = "networking.catchData"
        static let response = "networking.response"
        static let information = "networking.information"
        static let clientError = "networking.clientError"
        static let recursive = "networking.recursive"
        static let authError = "networking.authError"
        static let serverError = "networking.serverError"
    }
}

