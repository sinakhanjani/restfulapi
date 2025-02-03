//
//  APIRequest.swift
//  Master
//
//  Created by Sina khanjani on 11/27/1399 AP.
//

import Foundation
import Combine

@available(OSX 10.15, *)
public protocol APIRequest: Codable {
    associatedtype Response: Codable
    associatedtype Send: Codable
    
    var path: String { get }
    var parameters: Parameters? { get set }
    var auth: Authentication { get set }
    var queries: Queries? { get }
    var method: Method { get }
    var body: Send? { get }
    var urlRequest: URLRequest? { get }
    var subscriptions: [AnyCancellable] { get set }
    
    func decodeResponse(data: Data) throws -> Response
    func encodeResponse() throws -> Data
    func headerField() -> Dictionary<String,String>
}

@available(OSX 10.15, *)
public extension APIRequest {
    private var baseURL: URL? { URL(string: Config.standard.baseURL) }
    
    var urlRequest: URLRequest? {
        if var url = baseURL?.appendingPathComponent(path) {
            if let queries = queries {
                url.withQueries(queries)
            }
            
            var request = URLRequest(url: url)
            
            request.httpMethod = method.value
            request.httpBody = try? encodeResponse()
            request.allHTTPHeaderFields = headerField()
            
            return request
        }
        
        return nil
    }
    /// Use this method for POST request with GCD
    func sendURLSessionRequest(completion: @escaping (Result<(object: Response, httpURLResponse: HTTPURLResponse), Error>) -> Void) {
        guard let urlRequest = urlRequest else {
            completion(.failure(ApiError.badRequest))
            return
        }
        print("Send to URL: \(urlRequest.url!)")
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = Config.standard.timeoutIntervalForRequest
        sessionConfig.timeoutIntervalForResource = Config.standard.timeoutIntervalForResource
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data, let httpResponse = response as? HTTPURLResponse {
                if let str = String(data: data, encoding: .utf8) {
                    print(str)
                }
                do {
                    let decodedResponse = try self.decodeResponse(data: data)
                    completion(.success((object: decodedResponse, httpURLResponse: httpResponse)))
                    
                } catch {
                    print("Error: \(error)")
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    /// Use this method for request without GCD
    func sendURLSessionRequest() throws -> (object: Response, httpURLResponse: HTTPURLResponse) {
        guard let urlRequest = urlRequest else {
            throw ApiError.badRequest
        }
        print("Send to URL: \(urlRequest.url!)")
        
        let sem = DispatchSemaphore(value: 0)
        var decodedResponse: Self.Response?
        var httpResponse: HTTPURLResponse?
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = Config.standard.timeoutIntervalForRequest
        sessionConfig.timeoutIntervalForResource = Config.standard.timeoutIntervalForResource
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            defer { sem.signal() }
            
            if let data = data {
                if let str = String(data: data, encoding: .utf8) {
                    print(str)
                }
                if let decoded = try? self.decodeResponse(data: data), let httpURLResponse = response as? HTTPURLResponse {
                    decodedResponse = decoded
                    httpResponse = httpURLResponse
                }
            }
        }
        
        task.resume()
        sem.wait()
        
        if let decodedResponse = decodedResponse , let httpResponse = httpResponse {
            return (object: decodedResponse, httpURLResponse: httpResponse)
        }
        
        throw ApiError.badResponse
    }
    // Use this method for POST request using URLSession’s async/await-powered APIs
    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    func sendURLSessionRequest() async throws -> Result<(object: Response, httpURLResponse: HTTPURLResponse), Error> {
        guard let urlRequest = urlRequest else {
            throw ApiError.badRequest
        }
        print("Send to URL: \(urlRequest.url!)")
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = Config.standard.timeoutIntervalForRequest
        sessionConfig.timeoutIntervalForResource = Config.standard.timeoutIntervalForResource
        let session = URLSession(configuration: sessionConfig)
        
        let (data, response) = try await session.data(for: urlRequest)
        if let utf8_string = String(data: data, encoding: .utf8) {
            print(utf8_string)
        }
        if let decodedResponse = try? decodeResponse(data: data), let httpResponse = response as? HTTPURLResponse {
            return Result<(object: Response, httpURLResponse: HTTPURLResponse), Error>.success((object: decodedResponse, httpURLResponse: httpResponse))
        } else {
            return Result<(object: Response, httpURLResponse: HTTPURLResponse), Error>.failure(ApiError.jsonDecoder(data))
        }
    }
    
    /// Use this method for GET request and fetch model data
    mutating func fetchDataTaskPublisherRequest(completion: @escaping (Result<Response, Error>) -> Void) {
        guard let urlRequest = urlRequest else {
            completion(.failure(ApiError.badRequest))
            return
        }
        print("Send to URL: \(urlRequest.url!)")
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = Config.standard.timeoutIntervalForRequest
        sessionConfig.timeoutIntervalForResource = Config.standard.timeoutIntervalForResource
        let session = URLSession(configuration: sessionConfig)
        
        let remoteDataPublisher = session.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: Response.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
        
        remoteDataPublisher
            .sink(receiveCompletion: { subscribeCompletion in
                switch subscribeCompletion {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    print("Finished fetch request at: \(String(describing: subscribeCompletion))")
                }
            }) { msgs in
                completion(.success(msgs))
            }
            .store(in: &subscriptions)
    }
}
