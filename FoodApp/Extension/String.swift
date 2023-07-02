import Foundation

extension String {
    
    func localized() -> String {
        
        NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self)
    }
}
