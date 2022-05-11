//
//  AutocompleteCity.swift
//  RxWeather MVVM
//
//  Created by  Stepanok Ivan on 11.05.2022.
//

import Foundation

// MARK: - AutocompleteElement
public struct AutocompleteCity: Codable {
    public let placeID: String?
    public let osmID: String?
    public let osmType: String?
    public let licence: String?
    public let lat: String?
    public let lon: String?
    public let boundingbox: [String]?
    public let autocompleteClass: String?
    public let type: String?
    public let displayName: String?
    public let displayPlace: String?
    public let displayAddress: String?
    public let address: Address?

    enum CodingKeys: String, CodingKey {
        case placeID
        case osmID
        case osmType
        case licence
        case lat
        case lon
        case boundingbox
        case autocompleteClass
        case type
        case displayName
        case displayPlace
        case displayAddress
        case address
    }

    public init(placeID: String?, osmID: String?, osmType: String?, licence: String?, lat: String?, lon: String?, boundingbox: [String]?, autocompleteClass: String?, type: String?, displayName: String?, displayPlace: String?, displayAddress: String?, address: Address?) {
        self.placeID = placeID
        self.osmID = osmID
        self.osmType = osmType
        self.licence = licence
        self.lat = lat
        self.lon = lon
        self.boundingbox = boundingbox
        self.autocompleteClass = autocompleteClass
        self.type = type
        self.displayName = displayName
        self.displayPlace = displayPlace
        self.displayAddress = displayAddress
        self.address = address
    }
}

// MARK: - Address
public struct Address: Codable {
    public let name: String?
    public let county: String?
    public let state: String?
    public let postcode: String?
    public let country: String?
    public let countryCode: String?

    enum CodingKeys: String, CodingKey {
        case name
        case county
        case state
        case postcode
        case country
        case countryCode
    }

    public init(name: String?, county: String?, state: String?, postcode: String?, country: String?, countryCode: String?) {
        self.name = name
        self.county = county
        self.state = state
        self.postcode = postcode
        self.country = country
        self.countryCode = countryCode
    }
}

public typealias Autocomplete = [AutocompleteCity]
