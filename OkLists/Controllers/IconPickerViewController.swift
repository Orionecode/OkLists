//
//  IconPickerViewController.swift
//  OkLists
//
//  Created by 曾一笑 on 2022/4/5.
//

import UIKit

protocol IconPickerViewControllerDelegate: AnyObject {
    func iconPicker(
        _ picker: IconPickerViewController,
        didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    let icons = ["globe.asia.australia", "bolt.fill", "pencil", "wand.and.rays", "list.number", "alarm", "photo", "plus.rectangle.on.folder.fill"]
    let iconsName = ["Global", "Lightning", "Pencil", "Rays", "List", "Alarm", "Photo", "Folder"]
    
    weak var delegate: IconPickerViewControllerDelegate?
    
    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        cell.textLabel!.text = iconsName[indexPath.row]
        cell.imageView!.image = UIImage(systemName: icons[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPick: iconName)
        }
    }
}
