//
//  SearchedCityTableViewCell.swift
//  ForecastApp
//
//  Created by Hüdahan Altun on 3.08.2023.
//

import UIKit

class SearchedCityTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    
    @IBOutlet weak var minTemperature: UILabel!
    
    @IBOutlet weak var minTempUnderline: UILabel!
    
    
    @IBOutlet weak var maxTemperature: UILabel!
    
    @IBOutlet weak var maxTempUnderline: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        minTempUnderline.textColor = .white
        maxTempUnderline.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
