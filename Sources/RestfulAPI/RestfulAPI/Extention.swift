//
//  Extention.swift
//  JobLoyal
//
//  Created by Sina khanjani on 12/11/1399 AP.
//

import Foundation

extension URL {
    public mutating func withQueries(_ queries:[String:Any]) {
        var components = URLComponents.init(url: self, resolvingAgainstBaseURL: true)!
        components.queryItems = queries.compactMap {
            URLQueryItem.init(name: $0.0, value: String(describing: $0.1))
        }
        
        self = components.url!
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

@available(macOS 10.15, *)
extension RestfulAPI {
    public func createDataBody(with parameters: Parameters?, files: Files?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        if let parameters = parameters {
            for (key,value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        if let files = files {
            for (file) in files {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(file.key)\"; filename=\"\("\(arc4random())" + file.mime)\"\(lineBreak)")
                body.append("Content-Type: \(file.mime + lineBreak + lineBreak)")
                body.append(file.data)
                body.append(lineBreak)
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}
