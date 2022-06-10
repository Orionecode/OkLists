//
//  ListDetailViewController.swift
//  CheckList
//
//  Created by 曾一笑 on 2022/4/4.
//

import UIKit

// MARK: - ListDetailViewController对当前页面的状态更改有控制权，相当于Boss，制定protocol规则
protocol ListViewControllerDetailDelegate: AnyObject {
    // 取消
    func listDetailViewControllerDidCancel(
        _ controller: ListDetailViewController)
    // 完成添加
    func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishAdding checklist: Checklist
    )
    // 修改项目
    func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishEditing checklist: Checklist
    )
}

// MARK: - UITableViewController
class ListDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImage: UIImageView!

    weak var delegate: ListViewControllerDetailDelegate?

    var checkListToEdit: Checklist?
    var iconName = "alarm"

    override func viewDidLoad() {
        super.viewDidLoad()

        if let checklist = checkListToEdit {
            title = "Edit CheckList"
            textField.text = checklist.name
            doneBarButton.isEnabled = true

            iconName = checklist.icon
        }
        iconImage.image = UIImage(systemName: iconName)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 使得键盘称为第一焦点
        textField.becomeFirstResponder()
    }

    // MARK: - Actions
    @IBAction func cancel(_ sender: Any) {
        // 用户点击取消时候，我将发送addItemViewControllerDidCancel消息发送回delegate
        delegate?.listDetailViewControllerDidCancel(self)
        navigationController?.popViewController(animated: true)
    }

    // 这里使用Connection Inspector sent Events 来确保点击键盘上的return也可以保存输入
    @IBAction func done(_ sender: Any) {
        // 用户在编辑已有的对象
        if let checklist = checkListToEdit {
            checklist.name = textField.text!
            checklist.icon = iconName
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
            navigationController?.popViewController(animated: true)
        }
        // 用户在创建新的对象
            else {
            // 用户点击完成按钮时候，我将传递一个新的ChecklistItem对象，并且该对象具有text
            let checklist = Checklist(name: textField.text!, icon: iconName)
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
            navigationController?.popViewController(animated: true)
        }
    }
    // MARK: - Table View Delegates
    override func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil
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
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}

extension ListDetailViewController: IconPickerViewControllerDelegate {
    // MARK: - 接受IconPickerViewControllerDelegate，自动调用
    func didPickedIcon(_ picker: IconPickerViewController, didPick iconName: String) {
        //执行来自IconPickerView的命令
        self.iconName = iconName
        iconImage.image = UIImage(systemName: iconName)
    }
    
    // MARK: - SB Segue Navigation Link to IconPickerView
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.iconPickerDelegate = self
        }
    }
}
