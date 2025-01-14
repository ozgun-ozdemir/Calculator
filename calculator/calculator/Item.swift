//
//  Item.swift
//  calculator
//
//  Created by Ozgun Umut Ozdemir on 1/14/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
