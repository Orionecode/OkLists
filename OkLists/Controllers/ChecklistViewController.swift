//
//  ChecklistViewController.swift
//  CheckList
//
//  Created by 曾一笑 on 2022/3/26.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    var checklist: Checklist!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name

    }

    // MARK: - 界面样式，渲染行数
    
    // 生成Table View，确定渲染行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return checklist.items.count;
    }

    // 渲染每一行的Cell 返回的也是UITableViewCell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)

        // Configure the cell...
        let item = checklist.items[indexPath.row]
        // 这里需要先配置Text为初始化的值
        configureText(for: cell, with: item)
        // 再配置Checkmark为初始化的值
        configureCheckmark(for: cell, with: item)
        return cell
    }

    // MARK: - 界面交互
    // Override to support editing the table view.
    // 添加删除功能
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 从data model中移除项目
        checklist.items.remove(at: indexPath.row)
        //从表视图中删除相应的行
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    // 设定选中点击效果，并且使点击效果生效
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.checked.toggle()
            // 更新视图上的CheckMark
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // 更新checkmark
    func configureCheckmark(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if (item.checked) {
            label.text = "✔︎"
        } else {
            label.text = ""
        }
    }

    // 配置文字
    func configureText(
        for cell: UITableViewCell,
        with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 由于每个View Controller可能会有多个segue，因此给定该segue一个唯一的标识符
        if (segue.identifier == "AddItem") {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if (segue.identifier == "EditItem") {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    // MARK: - 因为属于AddItemViewControllerDelegate对象，必须实现delegate中的所有方法
    
    // 取消
    func addItemViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    // 添加
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count

        checklist.items.append(item)

        let indexPath = IndexPath(row: newRowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        navigationController?.popViewController(animated: true)
        
    }
    
    // 修改
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        // 要创建需要检索单元格的IndexPath，您首先需要找到此ChecklistItem的行号。行号与项目数组中ChecklistItem的索引相同——您可以使用firstInde
        // （of:）方法返回
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}
