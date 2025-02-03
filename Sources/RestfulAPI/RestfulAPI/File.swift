//
//  File.swift
//  
//
//  Created by Sina khanjani on 2/5/1400 AP.
//

import Foundation

public struct File: Codable {
    public enum MimeType: String {
        case jpg = ".jpg"
        case png = ".png"
        case pdf = ".pdf"
        case mp4 = ".mp4"
        case mov = ".mov"
        case doc = ".docx"
        case mp3 = ".mp3"
    }
    
    public let key: String
    public let data: Data
    public let mime: String
    
    public init(key: String, data: Data, mime: MimeType = .jpg) {
        self.key = key
        self.data = data
        self.mime = mime.rawValue
    }
}
