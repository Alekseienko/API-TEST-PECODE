//
//  FilterData.swift
//  API TEST PECODE
//
//  Created by alekseienko on 16.10.2022.
//

import Foundation

var filters: [FilterModel] = [
    FilterModel(type: ["Countries","top-headlines?country="], value: ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]),
    FilterModel(type: ["Category","top-headlines?category="], value: ["business", "entertainment", "general", "health", "science", "sports", "technology"]),
    FilterModel(type: ["Sources","top-headlines?sources="], value: ["bbc-news","techcrunch","the-wall-street-journal","the-verge","reuters","wired"])
]
