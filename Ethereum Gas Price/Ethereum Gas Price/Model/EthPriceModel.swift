//
//  EthPriceModel.swift
//  EthGasPrice
//
//  Created by Jing Song Du on 2020-01-15.
//  Copyright © 2020 Jing Song Du. All rights reserved.
//

import Foundation

public struct ETHPriceModel : Codable {
    public let current_price : Double

    enum CodingKeys: String, CodingKey {
        case current_price = "current_price"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        current_price = try values.decode(Double.self, forKey: .current_price)
    }

}
