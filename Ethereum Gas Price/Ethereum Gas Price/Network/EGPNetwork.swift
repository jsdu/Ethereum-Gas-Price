//
//  Networking.swift
//  ETHGasPrice
//
//  Created by Jing Song Du on 2020-01-14.
//  Copyright © 2020 Jing Song Du. All rights reserved.
//

import Foundation

public class EGPNetwork {
    public init() {}

    public func getAPIData(completion: @escaping (_ dataModel: ETHPriceModel) -> Void) {
        var request = URLRequest(url: URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=ethereum")!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in

            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode([ETHPriceModel].self, from: data!)
                completion(responseModel[0])
            } catch {
                print(error)
                print("JSON Serialization error")
            }
        }).resume()
    }

    public func getGasData(completion: @escaping (_ dataModel: ETHGasModel) -> Void) {
        var request = URLRequest(url: URL(string: "https://ethgasstation.info/json/ethgasAPI.json?api-key=\(apiKey)")!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in

            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(ETHGasModel.self, from: data!)
                completion(responseModel)
            } catch {
                print(error)
                print("JSON Serialization error")
            }
        }).resume()
    }
}
