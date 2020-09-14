//
//  ViewController.swift
//  AkiosTask18
//
//  Created by Nekokichi on 2020/09/13.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit

private struct CheckItem {
    var name : String!
    var check: Bool!
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
        let nvc         = segue.destination as! UINavigationController
        let addOrEditVC = nvc.viewControllers[0] as! AddOrEditViewController
        
        addOrEditVC.selectedIndexPathRow = checkListTableView.indexPathForSelectedRow?.row
        
        if segue.identifier == "addSegue" {
            addOrEditVC.segueIdentifier = "addSegue"
        }
        if segue.identifier == "editSegue" {
            guard let indexPathRow = sender as? Int else { return }
            addOrEditVC.segueIdentifier      = "editSegue"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "checklistcell", for: indexPath)
        guard let itemImageView = cell.viewWithTag(1) as? UIImageView else { return cell }
        guard let itemName      = cell.viewWithTag(2) as? UILabel else { return cell }
        
        if checkList[indexPath.row].check {
            itemImageView.image = UIImage(systemName: "checkmark")
        } else {
            itemImageView.image = nil
        }
        itemName.text           = checkList[indexPath.row].name
        
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

