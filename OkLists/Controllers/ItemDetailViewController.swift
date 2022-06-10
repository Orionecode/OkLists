//
//  AddItemViewController.swift
//  CheckList
//
//  Created by 曾一笑 on 2022/3/26.
//

import UIKit

// MARK: - ItemDetailViewController对当前页面的状态更改有控制权，相当于Boss，制定protocol规则
protocol ItemDetailViewControllerDelegate: AnyObject {
    // 取消
    func addItemViewControllerDidCancel(_ controller: ItemDetailViewController)
    // 添加
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    // 修改
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

// MARK: - UITableViewController
class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var doneBarButton: UIBarButtonItem!

    @IBOutlet weak var shouldRemindSwitch: UISwitch!

    @IBOutlet weak var datePicker: UIDatePicker!

    weak var itemDetailViewDelegate: ItemDetailViewControllerDelegate?

    var itemToEdit: ChecklistItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 如果item等于ItemToEdit
        if let item = itemToEdit {
            // 因为itemToEdit是可选项，所以这里需要对它进行包装
            title = "Edit Item"
            textField.text = item.text
            // 使Done按钮可用
            doneBarButton.isEnabled = true
            // 显示开关和时间
            shouldRemindSwitch.isOn = item.shouldRemind
            datePicker.date = item.dueDate
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 使得键盘称为第一焦点
        textField.becomeFirstResponder()
    }

    // MARK: - Actions
    @IBAction func cancel(_ sender: Any) {
        // 用户点击取消时候，我将发送addItemViewControllerDidCancel消息发送回delegate
        itemDetailViewDelegate?.addItemViewControllerDidCancel(self)
        navigationController?.popViewController(animated: true)
    }

    // 这里使用Connection Inspector sent Events 来确保点击键盘上的return也可以保存输入
    @IBAction func done(_ sender: Any) {
        // 用户在编辑已有的对象
        if let item = itemToEdit {
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()

            itemDetailViewDelegate?.itemDetailViewController(self, didFinishEditing: item)
            navigationController?.popViewController(animated: true)
        }
        // 用户在创建新的对象
            else {
            // 用户点击完成按钮时候，我将传递一个新的ChecklistItem对象，并且该对象具有text
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()

            itemDetailViewDelegate?.itemDetailViewController(self, didFinishAdding: item)
            navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        textField.resignFirstResponder()

        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { _, _ in
                // do nothing
            }
        }
    }

    // MARK: - Table View Delegates
    override func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        return nil
    }

    // MARK: - Text Field Delegates
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
