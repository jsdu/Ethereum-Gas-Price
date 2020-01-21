//
//  ETHGasModel.swift
//  EthGasPrice
//
//  Created by Jing Song Du on 2020-01-15.
//  Copyright © 2020 Jing Song Du. All rights reserved.
//

import Foundation

public struct ETHGasModel : Codable, Equatable, Hashable {
    public let fast : Double
    public let fastest : Double
    public let safeLow : Double
    public let average : Double
    public let block_time : Double
    public let blockNum : Int
    public let speed : Double
    public let safeLowWait : Double
    public let avgWait : Double
    public let fastWait : Double
    public let fastestWait : Double
    public let gasPriceRange : [String: Double]

    public let averageTransfer = 21000.0 // GWEI per transaction

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fast = try values.decode(Double.self, forKey: .fast)
        fastest = try values.decode(Double.self, forKey: .fastest)
        safeLow = try values.decode(Double.self, forKey: .safeLow)
        average = try values.decode(Double.self, forKey: .average)
        block_time = try values.decode(Double.self, forKey: .block_time)
        blockNum = try values.decode(Int.self, forKey: .blockNum)
        speed = try values.decode(Double.self, forKey: .speed)
        safeLowWait = try values.decode(Double.self, forKey: .safeLowWait)
        avgWait = try values.decode(Double.self, forKey: .avgWait)
        fastWait = try values.decode(Double.self, forKey: .fastWait)
        fastestWait = try values.decode(Double.self, forKey: .fastestWait)
        gasPriceRange = try values.decode([String: Double].self, forKey: .gasPriceRange)
    }
}
