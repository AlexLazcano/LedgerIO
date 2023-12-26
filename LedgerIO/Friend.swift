//
//  Friend.swift
//  LedgerIO
//
//  Created by Alex Lazcano on 2023-12-26.
//

import Foundation
import SwiftData

@Model
class Friend {
    @Attribute(.unique) var name: String
    init(name: String) {
        self.name = name
    }
}
