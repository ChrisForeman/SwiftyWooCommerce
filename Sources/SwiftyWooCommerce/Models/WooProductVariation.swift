//
//  WooProductVariation.swift
//  Tucker
//
//  Created by Chris Foreman on 5/28/20.
//  Copyright © 2020 Chris Foreman. All rights reserved.
//

import Foundation

//Barebones for what we need right now.

public struct WooProductVariantAttribute:Codable {
    
    public var id:Int
    public var name:String
    public var option:String
    
}

public struct WooProductVariation:Codable {
    
    public var id:Int
    public var price:Double
    public var attributes:[String:String]
    public var sku:String
    
    private enum CodingKeys:CodingKey {
        case price
        case attributes
        case sku
        case id
    }
    
    public init(from decoder: Decoder) throws {
        let container = try  decoder.container(keyedBy: CodingKeys.self)
        let priceString = try container.decode(String.self, forKey: .price)
        sku = try container.decode(String.self, forKey: .sku)
        price = Double(priceString) ?? 0.0
        //Decode attributes
        attributes = [:]
        let dictArray = try container.decode([WooProductVariantAttribute].self, forKey: .attributes)
        for attribute in dictArray {
            //Make all keys and values lowercased to ensure uniformity incase some are capitalized when others aren't
            let name = attribute.name.lowercased()
            let option = attribute.option.lowercased().replacingOccurrences(of: "amp;", with: "")
            attributes[name] = option
        }
        id = try container.decode(Int.self, forKey: .id)
    }
}

