//
//  WooListOrderRequest.swift
//  Tucker
//
//  Created by Chris Foreman on 12/27/19.
//  Copyright © 2019 Chris Foreman. All rights reserved.
//

import Foundation

public struct WooListOrdersRequest:RestAPIRequest {
    
    public enum Status:String {
        case any
        case pending
        case processing
        case onHold = "on-hold"
        case completed
        case cancelled
        case refunded
        case failed
        case trash
    }
    
    public enum Context:String {
        case view
        case edit
    }
    
    public enum SortDirection:String {
        case ascending = "asc"
        case descending = "desc"
    }
    
    public enum SortAttribute:String {
        case date
        case id
        case include
        case title
        case slug
    }
    
    public typealias ResponseType = [WooOrder]
    
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
    
    private func stringFor(_ date: Date) -> String {
        let formatter = DateFormatter()
        //Date format that WooCommerce uses
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.string(from: date)
    }
    
    ///Scope under which the request is made; determines fields present in response. Options: view and edit. Default is view
    public func context(_ value: Context) -> WooListOrdersRequest {
        return _addParam(name: "context", value: value.rawValue)
    }
    
    ///Current page of the collection. Default is 1.
    public func page(_ value: Int) -> WooListOrdersRequest {
        return _addParam(name: "page", value: "\(value)")
    }
    
    ///Maximum number of items to be returned in result set. Default is 10.
    public func perPage(_ value: Int) -> WooListOrdersRequest {
        //Limit requests to a maximum of 100
        let capValue = value <= 100 ? value : 100
        return _addParam(name: "per_page", value: "\(capValue)")
    }
    
    ///Limit results to those matching a string.
    public func search(_ value: String) -> WooListOrdersRequest {
        return _addParam(name: "search", value: value)
    }
    
    ///Limit response to resources published after a given ISO8601 compliant date.
    public func after(_ value: Date) -> WooListOrdersRequest {
        let dateString = stringFor(value)
        return _addParam(name: "after", value: dateString)
    }
    
    ///Limit response to resources published before a given ISO8601 compliant date.
    public func before(_ value: Date) -> WooListOrdersRequest {
        let dateString = stringFor(value)
        return _addParam(name: "before", value: dateString)
    }
    
    ///Ensure result set excludes specific IDs.
    public func exclude(_ value: [Int]) -> WooListOrdersRequest {
        return _addParam(name: "exclude", value: "\(value)")
    }
    
    ///Limit result set to specific ids.
    public func include(_ value: [Int]) -> WooListOrdersRequest {
        return _addParam(name: "include", value: "\(value)")
    }
    
    ///Offset the result set by a specific number of items.
    public func offset(_ value: Int) -> WooListOrdersRequest {
        return _addParam(name: "offset", value: "\(value)")
    }
    
    ///Order sort attribute ascending or descending. Options: asc and desc. Default is desc
    public func ordering(_ value: SortDirection) -> WooListOrdersRequest {
        return _addParam(name: "order", value: value.rawValue)
    }
    
    ///Sort collection by object attribute. Options: date, id, include, title and slug. Default is date.
    public func orderBy(_ value: SortAttribute) -> WooListOrdersRequest {
        return _addParam(name: "orderby", value: value.rawValue)
    }
    
    ///Limit result set to those of particular parent IDs.
    public func parent(_ value: [Int]) -> WooListOrdersRequest {
        return _addParam(name: "parent", value: "\(value)")
    }
    
    ///Limit result set to all items except those of a particular parent ID.
    public func parent_exclude(_ value: [Int]) -> WooListOrdersRequest {
        return _addParam(name: "parent_exclude", value: "\(value)")
    }
    
    ///Limit result set to orders assigned a specific status. Options: any, pending, processing, on-hold, completed, cancelled, refunded, failed and trash. Default is any.
    public func status(_ value: [Status]) -> WooListOrdersRequest {
        let statusArray = value.map { $0.rawValue }
        return _addParam(name: "status", value: "\(statusArray)")
    }
    
    ///Limit result set to orders assigned a specific customer.
    public func customer(_ value: Int) -> WooListOrdersRequest {
        return _addParam(name: "customer", value: "\(value)")
    }
    
    ///Limit result set to orders assigned a specific product.
    public func product(_ value: Int) -> WooListOrdersRequest {
        return _addParam(name: "product", value: "\(value)")
    }
    
    ///Number of decimal points to use in each resource. Default is 2.
    public func dp(_ value: Int) -> WooListOrdersRequest {
        return _addParam(name: "dp", value: "\(value)")
    }
    
    private func _addParam(name: String, value: String) -> WooListOrdersRequest {
        var newRequest = self
        if newRequest.parameters == nil { newRequest.parameters = [:] }
        newRequest.parameters?[name] = value
        return newRequest
    }
    
    //Keeps making calls until there aren't anymore orders to retrieve. Each time it retrieves a set of orders, the didRetrieve block will be called.
    //The boolean will be true once all orders have been retrieved.
    ///If one of the pages fails, just skip it for now.
    public func noLimitSend(didRetrieve: @escaping (Swift.Result<([WooOrder], Bool),Error>) -> Void) {
        guard let string = parameters?["page"], let page = Int(string) else { return }
        guard let string2 = parameters?["per_page"], let perPage = Int(string2) else { return }
        #if DEBUG
        print("New request page: \(page)")
        #endif
        send { (result) in
            switch result {
            case .success(let newOrders):
                //Means there's no more orders to get
                if newOrders.count < perPage {
                    didRetrieve(.success((newOrders, true)))
                    //Means there's still more orders on the next page
                }else{
                    //Need to call the completion block on this level and on the next recursion level.
                    didRetrieve(.success((newOrders, false)))
                    self.page(page + 1).noLimitSend(didRetrieve: { (result) in
                        didRetrieve(result)
                    })
                }
            case .failure(let err):
                didRetrieve(.failure(err))
            }
        }
        
    }
    
}
