//
//  WebsiteOrder.swift
//  Tucker
//
//  Created by Chris Foreman on 11/24/19.
//  Copyright © 2019 Chris Foreman. All rights reserved.
//

import Foundation

public struct WooOrder: Codable {
    
    let id: Int
    let parentID: Int
    let number: String
    let orderKey: String
    let createdVia: String
    let version: String
    let status: String
    let currency: String
    
    //WooCommerce formats these as Strings even though the documentation otherwise
    let dateCreated: String
    let dateCreatedGmt: String
    let dateModified: String
    let dateModifiedGmt: String
    
    let discountTotal: String
    let discountTax: String
    
    let shippingTotal: String
    let shippingTax: String
    let cartTax: String
    let total: String
    let totalTax: String
    
    let pricesIncludeTax: Bool
    
    let customerID: Int
    let customerIPAddress: String
    let customerUserAgent: String
    let customerNote: String
    
    let billing:WooBillingInfo
    let shipping: WooShippingInfo
    let paymentMethod: String
    let paymentMethodTitle: String
    let transactionID: String

    //WooCommerce formats these as Strings even though the documentation otherwise
    let datePaid: String?
    let datePaidGmt: String?
    let dateCompleted: String?
    let dateCompletedGmt: String?
    let cartHash: String
    
    let metaData: [WooMetaData]
    
    let lineItems: [WooLineItem]
    let taxLines: [WooTaxLine]
    let shippingLines: [WooShippingLine]
    let feeLines: [WooFeeLine]
    let couponLines: [WooCouponLine]
    let refunds: [WooRefundLine]
    
    var setPaid:Bool?
    
    
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
    var metaDict:[String:String] {
        var dict:[String:String] = [:]
        for metaItem in metaData {
            dict[metaItem.key] = metaItem.value
        }
        return dict
    }
    
    
}


//Because the structs below are closely related to the WooOrder struct and it is dependent on them, I'm putting them all in the same file.

struct WooBillingInfo: Codable {
    let firstName: String
    let lastName: String
    let company: String
    let address1: String
    let address2: String
    let city: String
    let state: String
    let postcode: String
    let country: String
    let email: String
    let phone: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case company
        case address1 = "address_1"
        case address2 = "address_2"
        case city, state, postcode, country, email, phone
    }
}


struct WooShippingInfo: Codable {
    let firstName, lastName, company, address1: String
    let address2, city, state, postcode: String
    let country: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case company
        case address1 = "address_1"
        case address2 = "address_2"
        case city, state, postcode, country
    }
}


struct WooLineItem: Codable {
    let id: Int
    let name: String
    let productID, variationID, quantity: Int
    let taxClass, subtotal, subtotalTax, total: String
    let totalTax: String
    let taxes: [String]
    let metaData: [WooMetaData]
    let sku: String?
    let price: Decimal
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case productID = "product_id"
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

struct NestedMetaShippingData: Codable {
    let file:String
    let url:String
    let type:String
    let error:Bool
    let shipment_id:String
}

struct WooMetaData: Codable {
    
    let id: Int
    let key:String
    let value: String
    let shippingData:NestedMetaShippingData?
    
    enum CodingKeys: String, CodingKey {
        case id
        case key
        case value
    }
    
    init(from decoder: Decoder) throws {
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

struct WooTaxLine: Codable {
    var id:Int
    var rateCode:String
    var rateID:String
    var label:String
    var compound:Bool
    var taxTotal:String
    var shippingTaxTotal:String
    var metaData:[WooMetaData]
    
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

struct WooShippingLine: Codable {
    var id:Int
    var methodTitle:String
    var methodID:String
    var total:String
    var totalTax:String
    var taxes:[WooTaxLine]
    var metaData:[WooMetaData]
    
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

struct WooFeeLine: Codable {
    var id:Int
    var name:String
    var taxClass:String
    var taxStatus:String
    var total:String
    var totalTax:String
    var taxes:String
    var metaData:[WooMetaData]
    
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

struct WooCouponLine: Codable {
    
    var id:Int
    var code:String
    var discount:String
    var discountTax:String
    var metaData:[WooMetaData]
    
    enum CodingKeys: String, CodingKey {
        case id
        case code
        case discount
        case discountTax = "discount_tax"
        case metaData = "meta_data"
    }
    
}

struct WooRefundLine: Codable {
    //Don't need coding keys for this one
    var id:Int
    var reason:String
    var total:String
    
}
