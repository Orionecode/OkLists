//
//  ListDetailViewController.swift
//  CheckList
//
//  Created by 曾一笑 on 2022/4/4.
//

import UIKit

protocol ListViewControllerDelegate: AnyObject {
    func listDetailViewControllerDidCancel(
        _ controller: ListDetailViewController)

    func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishAdding checklist: Checklist
    )

    func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishEditing checklist: Checklist
    )
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ListViewControllerDelegate?
    
    var checkListToEdit: Checklist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = checkListToEdit {
            title = "Edit CheckList"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 使得键盘称为第一焦点
        textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func cancel(_ sender: Any) {
        // 用户点击取消时候，我将发送addItemViewControllerDidCancel消息发送回delegate
        delegate?.listDetailViewControllerDidCancel(self)
    }

    // 这里使用Connection Inspector sent Events 来确保点击键盘上的return也可以保存输入
    @IBAction func done(_ sender: Any) {
        // 用户在编辑已有的对象
        if let checklist = checkListToEdit {
            checklist.name = textField.text!
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        }
        // 用户在创建新的对象
        else {
            // 用户点击完成按钮时候，我将传递一个新的ChecklistItem对象，并且该对象具有text
            let checklist = Checklist(name: textField.text!)
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
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
      doneBarButton.isEnabled = !newText.isEmpty
      return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
      doneBarButton.isEnabled = false
      return true
    }
}
