//
//  CellComponent.swift
//  Chart
//
//  Created by Luis Henrique Tavares  Dibrowa Ferreira on 04/03/21.
//  Copyright © 2021 Luis Henrique Tavares  Dibrowa Ferreira. All rights reserved.
//

import UIKit

struct CellComponentDTO {
    let collor: Int
    let title: String
    let value: Double
}

class CellComponent: UIView {
    
    @IBOutlet weak var legendCollorView: UIView!
    @IBOutlet weak var investmentTitleLabel: UILabel!
    @IBOutlet weak var investmentValueLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var arrowIcon: UILabel!
    func fill(dto: CellComponentDTO, hideAmount: Bool) {
        let valueMock = 500000.00
        let percentValue = dto.value/100 * valueMock
        
        legendCollorView.setRounded()
        legendCollorView.backgroundColor = UIColor(hex: dto.collor)
        investmentTitleLabel.text = dto.title
        let value = hideAmount ? "R$ **********" : convertDoubleToCurrency(amount: percentValue)
        investmentValueLabel.text = value
    }
    
    func convertDoubleToCurrency(amount: Double) -> String{
        let numberFormatter = NumberFormatter()
        let usLocale = Locale(identifier: "pt-BR")
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = usLocale
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
}
