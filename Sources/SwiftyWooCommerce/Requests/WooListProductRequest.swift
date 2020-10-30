//
//  WooListProductRequest.swift
//  Tucker
//
//  Created by Chris Foreman on 12/28/19.
//  Copyright © 2019 Chris Foreman. All rights reserved.
//

import Foundation

public struct WooListProductsRequest:RestAPIRequest {
    
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
    
    public enum Status:String {
        case any
        case draft
        case pending
        //private is a reserved word in swift
        case private_ = "private"
        case publish
    }
    
    public enum ProductType:String {
        case simple
        case grouped
        case external
        case variable
    }
    
    public enum TaxClass:String {
        case standard
        case reducedRate = "reduced-rate"
        case zeroRate = "zero-rate"
    }
    
    public enum StockStatus:String {
        case inStock = "instock"
        case outOfStock = "outofstock"
        case onBackOrder = "onbackorder"
    }
    
    public typealias ResponseType = [WooProduct]
    
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
    
    private func _stringFor(_ date: Date) -> String {
        let formatter = DateFormatter()
        //Date format that WooCommerce uses
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.string(from: date)
    }

    
    ///Scope under which the request is made; determines fields present in response. Options: view and edit. Default is view.
    public func context(_ value: Context) -> WooListProductsRequest {
        return _addParam(name: "context", value: value.rawValue)
    }
    
    ///Current page of the collection. Default is 1.
    public func page(_ value: Int) -> WooListProductsRequest {
        return _addParam(name: "page", value: String(value))
    }
    
    ///Maximum number of items to be returned in result set. Default is 10.
    public func perPage(_ value: Int) -> WooListProductsRequest {
        return _addParam(name: "per_page", value: String(value))
    }
    
    ///Limit results to those matching a string.
    public func search(_ value: String) -> WooListProductsRequest {
        return _addParam(name: "search", value: String(value))
    }
    
    ///Limit response to resources published after a given ISO8601 compliant date.
    public func after(_ date: Date) -> WooListProductsRequest {
        return _addParam(name: "after", value: _stringFor(date))
    }
    
    ///Limit response to resources published before a given ISO8601 compliant date.
    public func before(_ date: Date) -> WooListProductsRequest {
        return _addParam(name: "before", value: _stringFor(date))
    }
    
    ///Ensure result set excludes specific IDs.
    public func exclude(_ ids: [Int]) -> WooListProductsRequest {
        return _addParam(name: "exclude", value: String(describing: ids))
    }

    ///Limit result set to specific ids.
    public func include(_ ids: [Int]) -> WooListProductsRequest {
        return _addParam(name: "include", value: String(describing: ids))
    }

    ///Offset the result set by a specific number of items.
    public func offset(_ value: Int) -> WooListProductsRequest {
        return _addParam(name: "offset", value: String(value))
    }
    
    ///Order sort attribute ascending or descending. Options: asc and desc. Default is desc.
    public func order(_ direction: SortDirection) -> WooListProductsRequest {
        return _addParam(name: "order", value: direction.rawValue)
    }
    
    ///Sort collection by object attribute. Options: date, id, include, title and slug. Default is date.
    public func orderBy(_ attribute: SortAttribute) -> WooListProductsRequest {
        return _addParam(name: "orderby", value: attribute.rawValue)
    }
    
    ///Limit result set to those of particular parent IDs.
    public func parent(_ ids: [Int]) -> WooListProductsRequest {
        return _addParam(name: "parent", value: String(describing: ids))
    }
    
    ///Limit result set to all items except those of a particular parent ID.
    public func parentExclude(_ ids: [Int]) -> WooListProductsRequest {
        return _addParam(name: "parent_exclude", value: String(describing: ids))
    }
    
    ///Limit result set to products with a specific slug
    public func slug(_ value: String) -> WooListProductsRequest {
        return _addParam(name: "slug", value: String(value))
    }
    
    ///Limit result set to products assigned a specific status. Options: any, draft, pending, private and publish. Default is any.
    public func status(_ status: Status) -> WooListProductsRequest {
        return _addParam(name: "status", value: status.rawValue)
    }
    
    ///Limit result set to products assigned a specific type. Options: simple, grouped, external and variable
    public func type(_ productType: ProductType) -> WooListProductsRequest {
        return _addParam(name: "type", value: productType.rawValue)
    }
    
    ///Limit result set to products with a specific SKU.
    public func sku(_ value: String) -> WooListProductsRequest {
        return _addParam(name: "sku", value: String(value))
    }
    
    ///Limit result set to featured products.
    public func featured(_ value: Bool) -> WooListProductsRequest {
        return _addParam(name: "featured", value: String(value))
    }
    
    ///Limit result set to products assigned a specific category ID.
    public func category(_ value: String) -> WooListProductsRequest {
        return _addParam(name: "category", value: String(value))
    }
    
    ///Limit result set to products assigned a specific tag ID.
    public func tag(_ value: String) -> WooListProductsRequest {
        return _addParam(name: "tag", value: String(value))
    }
    
    ///Limit result set to products assigned a specific shipping class ID.
    public func shippingClass(_ value: String) -> WooListProductsRequest {
        return _addParam(name: "shipping_class", value: String(value))
    }
    
    ///Limit result set to products with a specific attribute.
    public func attribute(_ value: String) -> WooListProductsRequest {
        return _addParam(name: "attribute", value: String(value))
    }
    
    ///Limit result set to products with a specific attribute term ID (required an assigned attribute).
    public func attributeTerm(_ value: String) -> WooListProductsRequest {
        return _addParam(name: "attribute_term", value: String(value))
    }
    
    ///Limit result set to products with a specific tax class. Default options: standard, reduced-rate and zero-rate.
    public func taxClass(_ taxClass: TaxClass) -> WooListProductsRequest {
        return _addParam(name: "tax_class", value: taxClass.rawValue)
    }
    
    ///Limit result set to products on sale.
    public func onSale(_ value: Bool) -> WooListProductsRequest {
        return _addParam(name: "on_sale", value: String(value))
    }
    
    ///Limit result set to products based on a minimum price.
    public func minPrice(_ value: Float) -> WooListProductsRequest {
        return _addParam(name: "min_price", value: String(value))
    }
    
    ///Limit result set to products based on a maximum price.
    public func maxPrice(_ value: Float) -> WooListProductsRequest {
        return _addParam(name: "max_price", value: String(value))
    }
    
    ///Limit result set to products with specified stock status. Options: instock, outofstock and onbackorder
    public func stockStatus(_ status: StockStatus) -> WooListProductsRequest {
        return _addParam(name: "stock_status", value: status.rawValue)
    }
    
    private func _addParam(name: String, value: String) -> WooListProductsRequest {
        var newRequest = self
        if newRequest.parameters == nil { newRequest.parameters = [:] }
        newRequest.parameters?[name] = value
        return newRequest
    }
    
    
    //Keeps making calls until there aren't anymore orders to retrieve. Each time it retrieves a set of orders, the didRetrieve block will be called.
    //The boolean will be true once all orders have been retrieved.
    public func noLimitSend(didRetrieve: @escaping (Swift.Result<([WooProduct], Bool),Error>) -> Void) {
        guard let string = parameters?["page"], let page = Int(string) else { return }
        guard let string2 = parameters?["per_page"], let perPage = Int(string2) else { return }
        #if DEBUG
        print("New product request page: \(page)")
        #endif
        send { (result) in
            switch result {
            case .success(let newProducts):
                //Means there's no more orders to get
                if newProducts.count < perPage {
                    didRetrieve(.success((newProducts, true)))
                    //Means there's still more orders on the next page
                }else{
                    didRetrieve(.success((newProducts, false)))
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
