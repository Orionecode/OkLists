//
//  Checklist.swift
//  CheckList
//
//  Created by 曾一笑 on 2022/4/4.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var items:[ChecklistItem] = [ChecklistItem]()

    init(name: String) {
        self.name = name
        super.init()
    }
}
