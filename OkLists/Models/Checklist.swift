//
//  Checklist.swift
//  CheckList
//
//  Created by 曾一笑 on 2022/4/4.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var icon = "alarm"
    var items:[ChecklistItem] = [ChecklistItem]()

    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
}
