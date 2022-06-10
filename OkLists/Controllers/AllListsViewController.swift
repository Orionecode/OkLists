//
//  AllListViewController.swift
//  CheckList
//
//  Created by 曾一笑 on 2022/4/4.
//

import UIKit

// MARK: - AllListsViewController必须接受来自ListViewControllerDetailDelegate中的命令，相当于 itern
extension AllListsViewController: ListViewControllerDetailDelegate {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
    }

    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
    }

    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
    }
    
    // MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowChecklist") {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
}

// MARK: - UITableViewController, UINavigationControllerDelegate
class AllListsViewController: UITableViewController, UINavigationControllerDelegate {
    var dataModel: DataModel!

    let cellIdentifier = "ChecklistCell"
    
    // viewDidAppear()在视图在屏幕上可见且动画完成后被调用。由于动画的发生，它们之间可能有半秒左右的差异。
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        let index = dataModel.indexSelectedChecklist
        if (index >= 0 && index < dataModel.lists.count
        ) {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    
    // viewDidLoad一般不会被二次调用，这里显示的是出于某种原因需要视图必须做一次的事情。
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // viewWillAppear()在viewDidAppear()之前，viewDidLoad之后被调用，当视图即将变得可见但动画还没有开始时。
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 刷新tableView
        tableView.reloadData()
    }
    

    // MARK: - Table view 相关设置

    // 配置要渲染的table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }

    // 配置cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        // 显示空cell或者有subtitle的cell
        if let tmp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
            cell = tmp
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        // Configure the cell...
        let checklist = dataModel.lists[indexPath.row]
        let count = checklist.countUncheckedItems()
        let iconImage = cell.imageView!
        
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        if (checklist.items.count == 0) {
            cell.detailTextLabel!.text = "No items"
        } else {
            cell.detailTextLabel!.text = (count == 0 ? "All Done" : "\(count) Remaining")
        }
        iconImage.image = UIImage(systemName: checklist.icon)
        
        return cell
    }

    // 添加删除功能
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 从data model中移除项目
        dataModel.lists.remove(at: indexPath.row)
        //从表视图中删除相应的行
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    // 添加修改功能
    override func tableView(
        _ tableView: UITableView,
        accessoryButtonTappedForRowWith indexPath: IndexPath
    ) {
        let controller = storyboard!.instantiateViewController(
            withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self

        let checklist = dataModel.lists[indexPath.row]
        controller.checkListToEdit = checklist

        navigationController?.pushViewController(
            controller,
            animated: true)
    }

    // 点击导航到Checklist
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 保持上次进入的状态
        dataModel.indexSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }

    // MARK: - Navigation Controller Delegates
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 是否按下按钮
        if (viewController === self) {
            // "如果你使用==，你在检查两个变量是否有相同的值。用===，你是在检查两个变量是否指向完全相同的对象。"
            dataModel.indexSelectedChecklist = -1
        }
    }
}
