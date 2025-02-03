//
//  Setting.swift
//  Master
//
//  Created by Sina khanjani on 10/17/1399 AP.
//

import Foundation

public struct Archive {
    static public let shared = Archive()
    
    private let defaults = UserDefaults.standard

    public func archiveJSON<T: Encodable>(value: T, key: String) {
        let data = try! JSONEncoder().encode(value)
        let string = String(data: data, encoding: .utf8)
        
        defaults.set(string, forKey: key)
    }

    public func unarchiveJSON<T: Decodable>(key: String) -> T? {
        guard let string = defaults.string(forKey: key),
            let data = string.data(using: .utf8) else { return nil }
        
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
