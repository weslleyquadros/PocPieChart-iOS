//
//  CellChartTableViewCell.swift
//  Chart
//
//  Created by Luis Henrique Tavares  Dibrowa Ferreira on 04/03/21.
//  Copyright © 2021 Luis Henrique Tavares  Dibrowa Ferreira. All rights reserved.
//

import UIKit

class CellChartTableViewCell: UITableViewCell {

    private let componentView: CellComponent = CellComponent.initFromNib()
    
    func fill(dto: CellComponentDTO, hideAmount: Bool) {
        componentView.fill(dto: dto, hideAmount: hideAmount)
        fillWithSubview(componentView)
    }
    
    func clearCell() {
        componentView.legendCollorView.alpha = 0.3
        componentView.investmentTitleLabel.alpha = 0.3
        componentView.investmentValueLabel.alpha = 0.3
        componentView.arrowIcon.alpha = 0.3
        componentView.lineView.alpha = 0
    }

    func normalCell() {
        componentView.legendCollorView.alpha = 1
        componentView.investmentTitleLabel.alpha = 1
        componentView.investmentValueLabel.alpha = 1
        componentView.arrowIcon.alpha = 1
        componentView.lineView.alpha = 1
    }
}
