import Foundation

typealias BackendOperationHandler<T: Codable> = (BackendOperationResult<T?, BackendError>) -> Void

enum BackendError: LocalizedError {
    case decodeError(description: String?)
    case information(description: String?, statusCode: Int)
    case redirection(description: String?, statusCode: Int)
    case authError(description: String?, statusCode: Int)
    case clientError(description: String?, statusCode: Int)
    case serverError(description: String?, statusCode: Int)
    case unresolved(description: String?, statusCode: Int)

    var statusCode: Int {
        switch self {
        case .decodeError(_):
            return 0
        case .information(_, let statusCode):
            return statusCode
        case .redirection(_, let statusCode):
            return statusCode
        case .authError(_, let statusCode):
            return statusCode
        case .clientError(_, let statusCode):
            return statusCode
        case .serverError(_, let statusCode):
            return statusCode
        case .unresolved(_, let statusCode):
            return statusCode
        }
    }

    var description: String? {
        switch self {
        case .decodeError(let description):
            return description
        case .information(let description, _):
            return description
        case .redirection(let description, _):
            return description
        case .authError(let description, _):
            return description
        case .clientError(let description, _):
            return description
        case .serverError(let description, _):
            return description
        case .unresolved(let description, _):
            return description
        }
    }
}

enum BackendOperationResult<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)
}

enum RequestType {
    case get
    case post
    case put
    case delete
    
    var value: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}

enum StatusCode {
    
    case information
    case success
    case resursive
    case authError
    case clientError
    case serverError
    
    static func returnResult(for code: Int) -> StatusCode {
        switch code {
        case (100 ... 199):
            return .information
        case (200 ... 299):
            return .success
        case (300 ... 399):
            return .resursive
        case (400 ... 400):
            return .authError
        case (401 ... 499):
            return .clientError
        case (500 ... 599):
            return .serverError
        default:
            return .serverError
        }
    }
}
