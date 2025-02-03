//
//  RestfulAPI.swift
//  Master
//
//  Created by Sina khanjani on 12/11/1399 AP.
//

import Foundation
import Combine

public typealias Queries = Dictionary<String, String>
public typealias Headers = Dictionary<String, String>
public typealias Parameters = Dictionary<String, String>
public typealias Files = [File]

@available(OSX 10.15, *)
private var association = [AnyCancellable]()

/// RestfulAPI<Send,Response>(path: String)
@available(OSX 10.15, *)
public class RestfulAPI<Send: Codable, Response: Codable>: Disposable, APIRequest {

    public private(set) var path: String
    public private(set) var queries: Queries?
    public private(set) var method: Method
    public private(set) var body: Send?
    public private(set) var boundary: String = "Boundary-\(NSUUID().uuidString)"

    public var auth: Authentication = .none
    public var parameters: Parameters?
    
    private var headers = Headers()

    public init(path: String) {
        self.path = path
        self.queries = nil
        self.method = .GET
        self.body = nil
        self.parameters = nil
    }

    public var subscriptions: [AnyCancellable] {
        get { association }
        set { association = newValue }
    }
    
    public func with(auth: Authentication) -> RestfulAPI {
        self.auth = auth

        return self
    }
    
    public func with(method: Method) -> RestfulAPI {
        self.method = method
        
        return self
    }
    
    public func with(queries: Queries) -> RestfulAPI {
        self.queries = queries
        
        return self
    }
    
    public func with(body: Send) -> RestfulAPI {
        self.body = body
        
        return self
    }

    public func with(parameters: Parameters) -> RestfulAPI {
        self.parameters = parameters
        
        return self
    }
    
    public func with(headers: Headers) -> RestfulAPI {
        for (key,value) in headers {
            self.headers[key] = value
        }
        
        return self
    }
    
    public func headerField() -> Headers {
        headers.updateValue("application/json", forKey: "Content-Type")
        
        Config.standard.headers.forEach { (header) in
            headers.updateValue(header.value, forKey: header.key)
        }
        
        if let token = auth.token {
            switch Config.standard.authorizationType {
            case .bearerToken:
                headers.updateValue("Bearer \(token)", forKey: "Authorization")
            case .token:
                headers.updateValue(token, forKey: "Authorization")
            case .basicAuth:
                break
            }
        }
        if (Send.self == Files.self) || (Send.self == File.self) || (parameters != nil) {
            headers.updateValue("multipart/form-data; boundary=\(boundary)", forKey: "Content-Type")
        }
        
        return headers
    }
    
    public func decodeResponse(data: Data) throws -> Response {
        do {
            if Response.self == Data.self {
                return data as! Response
            }
            
            return try JSONDecoder()
                .decode(Response.self, from: data)
        } catch {
            throw ApiError.jsonDecoder(data)
        }
    }
    
    public func encodeResponse() throws -> Data {
        do {
            if ((Send.self == Files.self) || (Send.self == File.self)) {
                var dataBody = Data()
                
                if let files = body as? Files {
                    dataBody = createDataBody(with: parameters, files: files, boundary: boundary)
                }
                if let file = body as? File {
                    dataBody = createDataBody(with: parameters, files: [file], boundary: boundary)
                }
                
                return dataBody
            }
            
            if let parameters = parameters {
                
                return createDataBody(with: parameters, files: nil, boundary: boundary)
            }
            
            if (Send.self == EMPTYMODEL.self) || method == .GET {
                throw ApiError.jsonEncoder
            }
            
            return try JSONEncoder().encode(body)
        } catch {
            throw ApiError.jsonDecoder(nil)
        }
    }
}
