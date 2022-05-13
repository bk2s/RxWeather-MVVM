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
    let humidity: Int
    let windSpeed: Double
    let windDegree: Int
}

class DailyWeatherCell: UITableViewCell {
    var model: DailyWeatherModel!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayNightMaxTemperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.acceptColors(selected)
    }
    
    public func bind(model: DailyWeatherModel) {
        self.model = model
        self.dayLabel.text = DateService.shared.dayFromUnixTime(time: model.day, dateCase: .day)
        self.dayNightMaxTemperatureLabel.text = model.maxDayTemperature.asString() + "⁰ / " + model.maxNightTemperature.asString() + "⁰"
        self.weatherIcon.image = UIImage(systemName: model.weatherIcon)
    }
    
    func acceptColors(_ isSelected: Bool) {
        switch isSelected {
        case true:
                self.dayNightMaxTemperatureLabel.textColor = UIColor(named: "IceBlueColor")
                self.dayLabel.textColor = UIColor(named: "IceBlueColor")
                self.weatherIcon.tintColor = UIColor(named: "IceBlueColor")
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                self.shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
                self.shadowView.layer.shadowColor = UIColor(named: "IceBlueColor")?.cgColor
                self.shadowView.layer.shadowOpacity = 0.3
                self.shadowView.layer.shadowRadius = 6
                self.shadowView.layer.shadowPath = UIBezierPath(roundedRect: self.shadowView.bounds,
                                                                cornerRadius: 2).cgPath
                self.shadowView.layer.shouldRasterize = true
                self.shadowView.layer.rasterizationScale = UIScreen.main.scale
            }
        case false:
            UIView.animate(withDuration: 0.2) {
            self.dayNightMaxTemperatureLabel.textColor = .black
            self.dayLabel.textColor = .black
            self.weatherIcon.tintColor = .black
            self.shadowView.layer.shadowOpacity = 0
            }

        }
    }
}
