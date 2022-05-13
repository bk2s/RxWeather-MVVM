//
//  HourlyWeatherCollectionViewCell.swift
//  RxWeather MVVM
//
//  Created by  Stepanok Ivan on 13.04.2022.
//

import UIKit

struct HourlyWeatherModel {
    let day: String
    let weatherImage: String
    let temperature: String
    
    init(day: Double, weatherImage: String, temp: Int) {
        self.day = DateService.shared.dayFromUnixTime(time: day, dateCase: .hour)
        self.weatherImage = weatherImage
        self.temperature = String(temp) + "⁰"
    }
}

class HourlyWeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    func bind(model: HourlyWeatherModel) {
        self.dayLabel.text = model.day
        self.weatherImage.image = UIImage(systemName: model.weatherImage)
        self.tempLabel.text = model.temperature
    }

}
