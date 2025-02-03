//
//  File.swift
//  
//
//  Created by Sina khanjani on 12/11/1399 AP.
//

import Foundation

public struct RestfulAPIConfiguration {
    
    public init() {
        
    }
    
    public func setup(_ completion: () -> APIConfiguration) {
        let apiConfig = completion()
        Config.standard.set(baseURL: apiConfig.baseURL)
        Config.standard.set(headers: apiConfig.headers)
        Config.standard.set(authorizationType: apiConfig.authorizationType)
        Config.standard.set(timeoutIntervalForRequest: apiConfig.timeoutIntervalForResource)
        Config.standard.set(timeoutIntervalForResource: apiConfig.timeoutIntervalForResource)
    }
}

public struct APIConfiguration {
    public var baseURL: String
    public var headers: Dictionary<String,String>
    public var authorizationType: AuthorizationType
    public var timeoutIntervalForRequest: TimeInterval
    public var timeoutIntervalForResource: TimeInterval
    
    public init(baseURL: String,
                headers: Dictionary<String,String> = [:],
                authorizationType: AuthorizationType = .bearerToken,
                timeoutIntervalForRequest: TimeInterval = 60.0,
                timeoutIntervalForResource: TimeInterval = 7.0) {
        self.baseURL = baseURL
        self.headers = headers
        self.authorizationType = authorizationType
        self.timeoutIntervalForRequest = timeoutIntervalForRequest
        self.timeoutIntervalForResource = timeoutIntervalForResource
    }
}

public enum AuthorizationType: Codable {
    case bearerToken
    case token
    case basicAuth
}
