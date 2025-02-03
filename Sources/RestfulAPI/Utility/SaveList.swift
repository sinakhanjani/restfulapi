//
//  ArchiveInjection.swift
//  Master
//
//  Created by Sina khanjani on 11/26/1399 AP.
//

import Foundation

public struct SaveList<T: Codable> {
    private let documentsDirectory =
       FileManager.default.urls(for: .documentDirectory,
       in: .userDomainMask).first!
    
    private let archiveURL: URL
    
    public init(path: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsURL
            .appendingPathComponent(path)
            .appendingPathExtension("ext")
        
        self.archiveURL = archiveURL
    }
    
    public func encode(_ model: T) {
        let encoder = PropertyListEncoder()
        do {
            let encodedT = try encoder.encode(model)
            try encodedT.write(to: archiveURL)
        } catch {
            print("Error encoding emojis: \(error)")
        }
    }
    
    func decode() -> [T]? {
        guard let data = try? Data(contentsOf: archiveURL) else {
            return nil
        }
        
        do {
            let decoder = PropertyListDecoder()
            let decodedT = try decoder.decode([T].self, from: data)
            
            return decodedT
        } catch {
            print("Error decoding model \(T.self): \(error)")
            return nil
        }
    }
}
