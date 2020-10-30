//
//  WooAPI.swift
//  Tucker
//
//  Created by Chris Foreman on 12/27/19.
//  Copyright © 2019 Chris Foreman. All rights reserved.
//

import Foundation

//Not using a singleton because don't need to manipulate the instance.
public class WooAPI {
    
    //Keys needed from your WooCommerce Website.
    private var publicKey:String
    private var privateKey:String
    
    private var rootEndpoint:String
    
    private static var _shared:WooAPI!
    
    //This is so we don't have to keep checking if "_shared" is nil or not.
    private static var shared:WooAPI {
        get {
            if _shared == nil {
                fatalError("The WooAPI has not been configured. Call the \"WooAPI.configure()\" method before using the API.")
            }
            return _shared
        }
    }
    
    //MARK: Setup
    
    private init(publicKey: String, privateKey: String, websiteURL: String) {
        self.publicKey = publicKey
        self.privateKey = privateKey
        self.rootEndpoint = websiteURL
    }
    
    public static func configure(publicKey: String, privateKey: String, websiteURL: String) {
        if WooAPI._shared != nil {
            #if DEBUG
            print("The WooCommerc API has already been configured. Reconfiguring...")
            #endif
        }
        WooAPI._shared = WooAPI(
            publicKey: publicKey,
            privateKey: privateKey,
            websiteURL: websiteURL
        )
    }
    
    private var authHeader:[String:String] {
        return ["Authorization":"Basic \(credentials)"]
    }
    
    private var credentials:String {
        guard let credentialData = "\(publicKey):\(privateKey)".data(using: String.Encoding.utf8) else { return "" }
        return credentialData.base64EncodedString(options: [])
    }
    
    public static func listOrders() -> WooListOrdersRequest {
        let endpoint = "\(shared.rootEndpoint)/orders"
        let request = WooListOrdersRequest(endPoint: endpoint, headers: shared.authHeader)
        return request
    }
    
    public static func listProducts() -> WooListProductsRequest {
        let endpoint = "\(shared.rootEndpoint)/products"
        let request = WooListProductsRequest(endPoint: endpoint, headers: shared.authHeader)
        return request
    }
    
    public static func listVariations(productID: String) -> WooProductVariationsRequest {
        let endpoint = "\(shared.rootEndpoint)/products/\(productID)/variations"
        let request = WooProductVariationsRequest(endPoint: endpoint, headers: shared.authHeader)
        return request
    }
    
    public static func retrieveOrder(_ number: String) -> WooOrderRequest {
        let endpoint = "\(shared.rootEndpoint)/orders/\(number)"
        let request = WooOrderRequest(endPoint: endpoint, headers: shared.authHeader)
        return request
    }
}
