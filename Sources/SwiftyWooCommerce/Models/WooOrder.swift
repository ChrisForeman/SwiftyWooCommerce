//
//  WebsiteOrder.swift
//  Tucker
//
//  Created by Chris Foreman on 11/24/19.
//  Copyright © 2019 Chris Foreman. All rights reserved.
//

import Foundation

public struct WooOrder: Codable {
    
    public let id: Int
    public let parentID: Int
    public let number: String
    public let orderKey: String
    public let createdVia: String
    public let version: String
    public let status: String
    public let currency: String
    
    //WooCommerce formats these as Strings even though the documentation otherwise
    public let dateCreated: String
    public let dateCreatedGmt: String
    public let dateModified: String
    public let dateModifiedGmt: String
    
    public let discountTotal: String
    public let discountTax: String
    
    public let shippingTotal: String
    public let shippingTax: String
    public let cartTax: String
    public let total: String
    public let totalTax: String
    
    public let pricesIncludeTax: Bool
    
    public let customerID: Int
    public let customerIPAddress: String
    public let customerUserAgent: String
    public let customerNote: String
    
    public let billing:WooBillingInfo
    public let shipping: WooShippingInfo
    public let paymentMethod: String
    public let paymentMethodTitle: String
    public let transactionID: String

    //WooCommerce formats these as Strings even though the documentation otherwise
    public let datePaid: String?
    public let datePaidGmt: String?
    public let dateCompleted: String?
    public let dateCompletedGmt: String?
    public let cartHash: String
    
    public let metaData: [WooMetaData]
    
    public let lineItems: [WooLineItem]
    public let taxLines: [WooTaxLine]
    public let shippingLines: [WooShippingLine]
    public let feeLines: [WooFeeLine]
    public let couponLines: [WooCouponLine]
    public let refunds: [WooRefundLine]
    
    public var setPaid:Bool?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case parentID = "parent_id"
        case number
        case orderKey = "order_key"
        case createdVia = "created_via"
        case version, status, currency
        case dateCreated = "date_created"
        case dateCreatedGmt = "date_created_gmt"
        case dateModified = "date_modified"
        case dateModifiedGmt = "date_modified_gmt"
        case discountTotal = "discount_total"
        case discountTax = "discount_tax"
        case shippingTotal = "shipping_total"
        case shippingTax = "shipping_tax"
        case cartTax = "cart_tax"
        case total
        case totalTax = "total_tax"
        case pricesIncludeTax = "prices_include_tax"
        case customerID = "customer_id"
        case customerIPAddress = "customer_ip_address"
        case customerUserAgent = "customer_user_agent"
        case customerNote = "customer_note"
        case billing, shipping
        case paymentMethod = "payment_method"
        case paymentMethodTitle = "payment_method_title"
        case transactionID = "transaction_id"
        case datePaid = "date_paid"
        case datePaidGmt = "date_paid_gmt"
        case dateCompleted = "date_completed"
        case dateCompletedGmt = "date_completed_gmt"
        case cartHash = "cart_hash"
        case metaData = "meta_data"
        case lineItems = "line_items"
        case taxLines = "tax_lines"
        case shippingLines = "shipping_lines"
        case feeLines = "fee_lines"
        case couponLines = "coupon_lines"
        case refunds
        case setPaid = "set_paid"
    }
    
    
    //WooCommerce formats meta data oddly, this will create a dictionary from the decodedMeta data for easier use.
    //If the metaData happens to have duplicate keys, one of them will be overwritten by the other.
    public var metaDict:[String:String] {
        var dict:[String:String] = [:]
        for metaItem in metaData {
            dict[metaItem.key] = metaItem.value
        }
        return dict
    }
    
    
}


//Because the structs below are closely related to the WooOrder public struct and it is dependent on them, I'm putting them all in the same file.

public struct WooBillingInfo: Codable {
    public let firstName: String
    public let lastName: String
    public let company: String
    public let address1: String
    public let address2: String
    public let city: String
    public let state: String
    public let postcode: String
    public let country: String
    public let email: String
    public let phone: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case company
        case address1 = "address_1"
        case address2 = "address_2"
        case city, state, postcode, country, email, phone
    }
}


public struct WooShippingInfo: Codable {
    public let firstName, lastName, company, address1: String
    public let address2, city, state, postcode: String
    public let country: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case company
        case address1 = "address_1"
        case address2 = "address_2"
        case city, state, postcode, country
    }
}


public struct WooLineItem: Codable {
    public let id: Int
    public let name: String
    public let parentName:String?
    public let productID, variationID, quantity: Int
    public let taxClass, subtotal, subtotalTax, total: String
    public let totalTax: String
    public let taxes: [String]
    public let metaData: [WooMetaData]
    public let sku: String?
    public let price: Decimal
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case productID = "product_id"
        case parentName = "parent_name"
        case variationID = "variation_id"
        case quantity
        case taxClass = "tax_class"
        case subtotal
        case subtotalTax = "subtotal_tax"
        case total
        case totalTax = "total_tax"
        case taxes
        case metaData = "meta_data"
        case sku, price
    }
}

public struct NestedMetaShippingData: Codable {
    public let file:String
    public let url:String
    public let type:String
    public let error:Bool
    public let shipment_id:String
}

public struct WooMetaData: Codable {
    
    public let id: Int
    public let key:String
    public let value: String
    public let shippingData:NestedMetaShippingData?
    
    enum CodingKeys: String, CodingKey {
        case id
        case key
        case value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        key = try container.decode(String.self, forKey: .key)
        shippingData = try? container.decode(NestedMetaShippingData.self, forKey: .value)
        //If we can't decode a String from the value key, then the string dictionary should be some value
        do {
            value = try container.decode(String.self, forKey: .value)
        }catch {
            value = ""
        }
        
    }
    
}

public struct WooTaxLine: Codable {
    public var id:Int
    public var rateCode:String
    public var rateID:String
    public var label:String
    public var compound:Bool
    public var taxTotal:String
    public var shippingTaxTotal:String
    public var metaData:[WooMetaData]
    
    enum CodingKeys: String, CodingKey {
        case id
        case rateCode = "rate_code"
        case rateID = "rate_id"
        case label
        case compound
        case taxTotal = "tax_total"
        case shippingTaxTotal = "shipping_tax_total"
        case metaData = "meta_data"
    }
    
}

public struct WooShippingLine: Codable {
    public var id:Int
    public var methodTitle:String
    public var methodID:String
    public var total:String
    public var totalTax:String
    public var taxes:[WooTaxLine]
    public var metaData:[WooMetaData]
    
    enum CodingKeys: String, CodingKey {
        case id
        case methodTitle = "method_title"
        case methodID = "method_id"
        case total
        case totalTax = "total_tax"
        case taxes
        case metaData = "meta_data"
    }
    
}

public struct WooFeeLine: Codable {
    public var id:Int
    public var name:String
    public var taxClass:String
    public var taxStatus:String
    public var total:String
    public var totalTax:String
    public var taxes:String
    public var metaData:[WooMetaData]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case taxClass = "tax_class"
        case taxStatus = "tax_status"
        case total
        case totalTax = "total_tax"
        case taxes
        case metaData = "meta_data"
    }
    
}

public struct WooCouponLine: Codable {
    
    public var id:Int
    public var code:String
    public var discount:String
    public var discountTax:String
    public var metaData:[WooMetaData]
    
    enum CodingKeys: String, CodingKey {
        case id
        case code
        case discount
        case discountTax = "discount_tax"
        case metaData = "meta_data"
    }
    
}

public struct WooRefundLine: Codable {
    //Don't need coding keys for this one
    public var id:Int
    public var reason:String
    public var total:String
    
}
