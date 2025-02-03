//
//  Config.swift
//  Master
//
//  Created by Sina khanjani on 12/11/1399 AP.
//

import Foundation

public struct Config: Codable {
    
    public init() { }
    
    public static var standard = Config()
    
    public private(set) var baseURL = ""
    public private(set) var headers = Headers()
    public private(set) var authorizationType: AuthorizationType = .bearerToken
    public private(set) var timeoutIntervalForRequest: TimeInterval = 60.0
    public private(set) var timeoutIntervalForResource: TimeInterval = 7.0
    
    public mutating func set(baseURL: String) {
        self.baseURL = baseURL
    }
    public mutating func set(headers: Headers) {
        self.headers = headers
    }
    public mutating func set(authorizationType: AuthorizationType) {
        self.authorizationType = authorizationType
    }
    public mutating func set(timeoutIntervalForRequest: TimeInterval) {
        self.timeoutIntervalForRequest = timeoutIntervalForRequest
    }
    public mutating func set(timeoutIntervalForResource: TimeInterval) {
        self.timeoutIntervalForResource = timeoutIntervalForResource
    }
}
