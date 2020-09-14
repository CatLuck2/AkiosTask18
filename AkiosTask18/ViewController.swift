//
//  ViewController.swift
//  AkiosTask18
//
//  Created by Nekokichi on 2020/09/13.
//  Copyright © 2020 Nekokichi. All rights reserved.
//参考：http://two-island.com/2017/02/28/%E3%80%90xcode%E3%81%AE%E3%81%8A%E5%8B%89%E5%BC%B7%E3%80%91outlet-cannot-connected-repeating-content%E3%81%AB%E5%AF%BE%E5%BF%9C%E3%81%97%E3%81%A6tableviewcell%E3%82%B5%E3%83%96%E3%82%AF%E3%83%A9/#UITableViewCell

import UIKit

private struct CheckItem {
    var name : String
    var check: Bool
}

class CheckItemTableViewCell: UITableViewCell {
    @IBOutlet fileprivate weak var checkItemImageView: UIImageView!
    @IBOutlet fileprivate weak var checkItemLabel: UILabel!
}

final class ViewController: UIViewController {

    @IBOutlet private weak var checkListTableView: UITableView!
    private var checkList:[CheckItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkListTableView.delegate   = self
        checkListTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nvc = segue.destination as? UINavigationController else { return }
        guard let addOrEditVC = nvc.viewControllers[0] as? AddOrEditViewController else { return }
        
        addOrEditVC.selectedIndexPathRow = checkListTableView.indexPathForSelectedRow?.row
        
        if segue.identifier == "addSegue" {
            addOrEditVC.mode = .add
        }
        if segue.identifier == "editSegue" {
            guard let indexPathRow = sender as? Int else { return }
            addOrEditVC.mode                 = .edit
            addOrEditVC.selectedIndexPathRow = indexPathRow
            addOrEditVC.inputText            = checkList[sender as! Int].name
        }
    }
    
    
    @IBAction func unwindToVC(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "completeAdd" {
            let addOrEditVC   = unwindSegue.source as! AddOrEditViewController
            let betaCheckItem = CheckItem(name: addOrEditVC.inputText, check: false)
            checkList.append(betaCheckItem)
            checkListTableView.reloadData()
        }
        if unwindSegue.identifier == "completeEdit" {
            let addOrEditVC          = unwindSegue.source as! AddOrEditViewController
            let betaCheckItem        = CheckItem(name: addOrEditVC.inputText, check: false)
            let indexPathRow         = addOrEditVC.selectedIndexPathRow
            checkList[indexPathRow!] = betaCheckItem
            checkListTableView.reloadData()
        }
    }

}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checklistcell", for: indexPath) as! CheckItemTableViewCell
        
        if checkList[indexPath.row].check {
            cell.checkItemImageView.image = UIImage(systemName: "checkmark")
        } else {
            cell.checkItemImageView.image = nil
        }
        cell.checkItemLabel.text = checkList[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkList[indexPath.row].check.toggle()
        checkListTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)!.accessoryType == .detailButton {
            performSegue(withIdentifier: "editSegue", sender: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            checkList.remove(at: indexPath.row)
            checkListTableView.reloadData()
        }
    }
}

