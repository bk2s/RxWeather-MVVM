//
//  DailyWeatherCell.swift
//  RxWeather MVVM
//
//  Created by  Stepanok Ivan on 11.05.2022.
//

import UIKit

struct DailyWeatherModel {
    let day: Double
    let maxDayTemperature: Double
    let maxNightTemperature: Double
    let weatherIcon: String
    let isSelected: Bool
}

class DailyWeatherCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayNightMaxTemperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func bind(model: DailyWeatherModel) {
        self.acceptColors(model.isSelected)
        self.dayLabel.text = DateService.shared.dayFromUnixTime(time: model.day, dateCase: .day)
        self.dayNightMaxTemperatureLabel.text = model.maxDayTemperature.asString() + "⁰ / " + model.maxNightTemperature.asString() + "⁰"
        self.weatherIcon.image = UIImage(systemName: model.weatherIcon)
    }
    
    private func acceptColors(_ isSelected: Bool) {
        switch isSelected {
        case true:
           break
        case false:
           break
        }
    }
}
