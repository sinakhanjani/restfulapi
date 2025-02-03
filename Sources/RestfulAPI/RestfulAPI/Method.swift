//
//  Method.swift
//  Master
//
//  Created by Sina khanjani on 12/11/1399 AP.
//

import Foundation

public enum Method: String, Codable {
    case GET, POST, PUT, DELETE, PATCH
    
    var value: String { rawValue }
}
