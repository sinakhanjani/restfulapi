//
//  Authentication.swift
//  Master
//
//  Created by Sina khanjani on 12/11/1399 AP.
//

import Foundation

public enum Authentication: String, Codable, CaseIterable {
    case none
    case auth1 = "auth1_token"
    case auth2 = "auth2_token"
    case auth3 = "auth3_token"
    case auth4 = "auth4_token"
    // Properties
    private var key: String {
        rawValue
    }
    public var isLogin: Bool {
        (token == nil) ? false : true
    }
    public private(set) var token: String? {
        get {
            Archive.shared.unarchiveJSON(key: key)
        }
        set {
            Archive.shared.archiveJSON(value: newValue, key: key)
        }
    }
    // Methods
    public mutating func authenticate(token: String) {
        self.token = token
    }
    
    public mutating func logout() {
        self.token = nil
    }
}


