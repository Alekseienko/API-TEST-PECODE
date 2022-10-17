//
//  FilterNews.swift
//  API TEST PECODE
//
//  Created by alekseienko on 16.10.2022.
//

import Foundation


class FilterModel {
    var type: [String]
    var value: [String]
    
    init(type: [String], value: [String]) {
        self.type = type
        self.value = value
    }
}
