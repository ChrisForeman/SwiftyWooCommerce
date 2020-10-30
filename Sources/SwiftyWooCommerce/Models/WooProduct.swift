//
//  WooProduct.swift
//  Tucker
//
//  Created by Chris Foreman on 11/4/19.
//  Copyright © 2019 Chris Foreman. All rights reserved.
//

import Foundation


public struct WooProductResponse:Codable {
    public var products:[WooProduct]
}

public struct WooProductCategory:Codable {
    
    public var id:Int
    public var name:String
    public var slug:String
    
}

//Used to organize product info when reqeuesting from the WooAPI
public struct WooProduct:Codable {
    
    public var id:Int
    
    public var name:String
    
    public var attributeOptions:[String:[String]]

    public var variations:[Int]
    
    public var categories:[WooProductCategory]
    
    private enum CodingKeys:String, CodingKey {
        case name = "name"
        case attributeOptions = "attributes"
        case variations
        case id
        case categories
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //Decode the product name
        name = try container.decode(String.self, forKey: .name).lowercased()
        //Decode the attributes into a dictionary
        attributeOptions = [:]
        let dictArray = try container.decode([AttributeOptionSet].self, forKey: .attributeOptions)
        for attribute in dictArray {
            //Make all keys and values lowercased to ensure uniformity incase some are capitalized when others aren't
            attributeOptions[attribute.name.lowercased()] = attribute.options.map { $0.lowercased().replacingOccurrences(of: "amp;", with: "") }
        }
//        //Decode variations
        variations = try container.decode([Int].self, forKey: .variations)
        
        id = try container.decode(Int.self, forKey: .id)
        categories = try container.decode([WooProductCategory].self, forKey: .categories)
    }

}


fileprivate struct AttributeOptionSet:Codable {
    public var name:String
    public var options:[String]
}
