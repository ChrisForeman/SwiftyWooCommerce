//
//  File.swift
//
//
//  Created by Chris Foreman on 8/12/20.
//

import Foundation

///Can be used to quickly create a request that doesn't need any custom method chaining.
public struct GenericRestAPIRequest<T:Decodable>:RestAPIRequest {
    
    public typealias ResponseType = T
    
    public var headers: [String : String]?
    
    public var parameters: [String : String]?
    
    public var endPoint: String
    
    public var body: Data?
    
    public var method: HTTPMethod
    
}
