//
//  CommonModels.swift
//  W3-Project1-Gumi
//
//  Created by Thành Nguyên on 30/03/2021.
//

import UIKit

enum Tag : Int, CaseIterable {
    case UNDEFINED
    case NATURAL
    case ANIMAL
    case FOOD
    case PERSON
    case PARTY
    case TECHNICAL
    case FASHION
    case GAME
    case ACTIVE
    case ART
    
}

class Photo {
    var url : URL? = nil
    var title = "Unknown"
    var tag = Tag.init(rawValue: 0)
    
    init(url: String, title: String, tag: Tag) {
        self.url = URL(string: url)
        self.title = title
        self.tag = tag
    }
    
    init(url: String) {
        self.url = URL(string: url)
    }
}
