//
//  CityTableViewCell.swift
//  ForecastApp
//
//  Created by Hüdahan Altun on 2.08.2023.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    @IBOutlet weak var temperatureUnderline: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
