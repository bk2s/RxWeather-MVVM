//
//  WeatherDetailsTableViewCell.swift
//  RxWeather MVVM
//
//  Created by  Stepanok Ivan on 13.04.2022.
//

import UIKit

enum WeatherDetail {
    case temperature
    case humidity
    case wind
}

struct WeatherDetailModel {
    let type: WeatherDetail
    let description: String
    let windDirection: Int?
}

class WeatherDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var leftImage: UIImageView! {
        didSet {
            self.leftImage.tintColor = .white
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rightImage: UIImageView! {
        didSet {
            self.rightImage.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func degImage(deg: Int) -> String {
        switch deg {
        case 337...360: return "arrow.up"
        case 0...22: return "arrow.up"
        case 23...67: return "arrow.up.right"
        case 68...112: return "arrow.right"
        case 113...157: return "arrow.down.right"
        case 158...202: return "arrow.down"
        case 203...247: return "arrow.down.left"
        case 248...292: return "arrow.left"
        case 293...336: return "arrow.up.left"
        default:
            return ""
        }
    }
    
    public func bind(model: WeatherDetailModel) {
        switch model.type {
            
        case .temperature:
            self.leftImage.image = UIImage(systemName: "thermometer")
            self.descriptionLabel.text = model.description
            self.rightImage.isHidden = true
        case .humidity:
            self.leftImage.image = UIImage(systemName: "humidity")
            self.descriptionLabel.text = model.description
            self.rightImage.isHidden = true
        case .wind:
            self.leftImage.image = UIImage(systemName: "wind")
            self.descriptionLabel.text = model.description
            self.rightImage.isHidden = false
            self.rightImage.image = UIImage(systemName: self.degImage(deg: model.windDirection ?? 0))
        }
    }
}
