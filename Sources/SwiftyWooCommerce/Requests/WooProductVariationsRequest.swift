//
//  WooListVariationRequest.swift
//  Tucker
//
//  Created by Chris Foreman on 5/28/20.
//  Copyright © 2020 Chris Foreman. All rights reserved.
//

import Foundation

public struct WooProductVariationsRequest:RestAPIRequest {
    
    public typealias ResponseType = [WooProductVariation]
       
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
    
    ///Current page of the collection. Default is 1.
    func page(_ value: Int) -> WooProductVariationsRequest {
        return _addParam(name: "page", value: String(value))
    }
    
    ///Maximum number of items to be returned in result set. Default is 10.
    func perPage(_ value: Int) -> WooProductVariationsRequest {
        return _addParam(name: "per_page", value: String(value))
    }
    
    private func _addParam(name: String, value: String) -> WooProductVariationsRequest {
        var newRequest = self
        if newRequest.parameters == nil { newRequest.parameters = [:] }
        newRequest.parameters?[name] = value
        return newRequest
    }
    
    //Keeps making calls until there aren't anymore orders to retrieve. Each time it retrieves a set of orders, the didRetrieve block will be called.
    //The boolean will be true once all orders have been retrieved.
    func noLimitSend(didRetrieve: @escaping (Swift.Result<([WooProductVariation], Bool),Error>) -> Void) {
        guard let string = parameters?["page"], let page = Int(string) else { return }
        guard let string2 = parameters?["per_page"], let perPage = Int(string2) else { return }
        #if DEBUG
        print("New variant request page: \(page)")
        #endif
        send { (result) in
            switch result {
            case .success(let newVariants):
                //Means there's no more orders to get
                if newVariants.count < perPage {
                    didRetrieve(.success((newVariants, true)))
                    //Means there's still more orders on the next page
                }else{
                    didRetrieve(.success((newVariants, false)))
                    self.page(page + 1).noLimitSend(didRetrieve: { (result) in
                        didRetrieve(result)
                    })
                }
            case .failure:
                //For now, if one page fails, we'll treat it as no products found on that page. and search the next page.
                didRetrieve(.success(([WooProductVariation](), false)))
            }
        }
        
    }
    
    
}
