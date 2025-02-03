//
//  Error.swift
//  Master
//
//  Created by Sina khanjani on 11/28/1399 AP.
//

import Foundation

public enum ApiError: Error, LocalizedError {
    case jsonDecoder(Data?)
    case jsonEncoder
    case badRequest
    case badData
    case badResponse
}
