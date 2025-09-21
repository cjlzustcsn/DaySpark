//
//  String+Localization.swift
//  DaySpark
//
//  Created for internationalization support
//

import Foundation

extension String {
    /// Returns the localized version of the string
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Returns the localized version of the string with a specific table
    func localized(tableName: String? = nil) -> String {
        return NSLocalizedString(self, tableName: tableName, comment: "")
    }
    
    /// Returns the localized version of the string with arguments
    func localized(_ arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
