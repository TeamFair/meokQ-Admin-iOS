//
//  Bundle++.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/7/24.
//

import Foundation

extension Bundle {
    var adminAuthToken: String {
        guard let filePath = Bundle.main.path(forResource: "PrivateToken", ofType: "plist"),
              let plistDict = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Couldn't find file 'PrivateToken.plist'.")
        }
        
        guard let value = plistDict.object(forKey: "AuthToken") as? String else {
            fatalError("Couldn't find key 'AuthToken' in 'PrivateToken.plist'.")
        }
        
        return value
    }
}
