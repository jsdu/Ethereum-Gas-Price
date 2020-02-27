//
//  TodayViewController.swift
//  Ethereum Gas Price Extension
//
//  Created by Jing Song Du on 2020-02-27.
//  Copyright © 2020 Jing Song Du. All rights reserved.
//

import Foundation
import UIKit

class TodayViewController: UIViewController {

    @IBOutlet weak var fastGwei: UILabel!
    @IBOutlet weak var standardGwei: UILabel!
    @IBOutlet weak var lowGwei: UILabel!

    var ethGasModel: ETHGasModel!
    var ethGasCost: Double!

    override func viewDidLoad() {
        getData()
    }

    func getData() {
        let client = EGPNetwork()
        client.getAPIData { (data) in
            client.getGasData { (ethGasModel) in
                DispatchQueue.main.async {
                    self.ethGasCost = data.current_price
                    self.ethGasModel = ethGasModel
                    self.setupUI()
                }
            }
        }
    }

    func setupUI() {
        fastGwei.text = formatGwei((ethGasModel.fastest))
        standardGwei.text = formatGwei((ethGasModel.average))
        lowGwei.text = formatGwei((ethGasModel.safeLow))
    }

    func formatGwei(_ returnedGwei: Double) -> String {
        return "\(returnedGwei/10) GWEI"
    }
}
