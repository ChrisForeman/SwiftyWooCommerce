//
//  WooOrderRequest.swift
//  Tucker
//
//  Created by Chris Foreman on 12/27/19.
//  Copyright © 2019 Chris Foreman. All rights reserved.
//

import Foundation

open class WooOrderRequest:RestAPIRequest {
    
    public typealias ResponseType = WooOrder
    
    public var headers: [String : String]?
    
    public var parameters: [String : String]?
    
    public var endPoint: String
    
    public var body: Data?
    
    public var method: HTTPMethod
    
    public init(endPoint:String, headers:[String:String]?) {
        self.endPoint = endPoint
        self.headers = headers
        self.parameters = nil
        self.body = nil
        self.method = .get
    }
    
    ///Number of decimal points to use in each resource.
    open func dp(_ value: String) -> WooOrderRequest {
        return _addParam(name: "dp", value: value)
    }
    
    private func _addParam(name: String, value: String) -> WooOrderRequest {
        let newRequest = self
        if newRequest.parameters == nil { newRequest.parameters = [:] }
        newRequest.parameters?[name] = value
        return newRequest
    }
    
}
