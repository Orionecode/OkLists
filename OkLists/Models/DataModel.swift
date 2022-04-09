//
//  DataModel.swift
//  CheckList
//
//  Created by 曾一笑 on 2022/4/5.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
        registerDefault()
        handleFirstTime()
    }
    
    // MARK: - Data persistence
    func documentsDirectory() -> URL {
      let paths = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask)
      print(paths[0])
      return paths[0]
    }

    func dataFilePath() -> URL {
      return documentsDirectory().appendingPathComponent("Checklists.plist")
    }

    // 保存checklists数据
    func saveChecklists() {
      let encoder = PropertyListEncoder()
      do {
        let data = try encoder.encode(lists)
        try data.write(
          to: dataFilePath(),
          options: Data.WritingOptions.atomic)
      } catch {
        print("Error encoding list array: \(error.localizedDescription)")
      }
    }
    
    // 加载checklists数据
    func loadChecklists() {
      let path = dataFilePath()
      if let data = try? Data(contentsOf: path) {
        let decoder = PropertyListDecoder()
        do {
          lists = try decoder.decode([Checklist].self, from: data)
          sortChecklists()
        } catch {
          print("Error decoding list array: \(error.localizedDescription)")
        }
      }
    }
    
    // MARK: - Register Default
    func registerDefault() {
        let dictionary = [
            "ChecklistIndex": -1,
            "FirstTime": true
        ] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    var indexSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    // MARK: - Handle the first lanch
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if (firstTime) {
            let checkList = Checklist(name: "Template List", icon: "alarm")
            lists.append(checkList)
            
            indexSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    
    // MARK: - Sort
    func sortChecklists() {
        lists.sort { list1, list2 in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
    }
    
    // MARK: - Notification
    // class method 可以直接使用itemID = DataModel.nextChecklistItemID()
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        return itemID
    }
}
