//
//  CountriesStatesModel.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 31/05/2021.
//

import UIKit

// MARK: - CountriesStatesModel

class CountriesStatesModel: Codable {
    let countries: [Country]?

    init(countries: [Country]?) {
        self.countries = countries
    }
}

// MARK: - Country
class Country: Codable {
    let country: String?
    let states: [String]?

    init(country: String?, states: [String]?) {
        self.country = country
        self.states = states
    }
}




