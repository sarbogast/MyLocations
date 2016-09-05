//
//  CategoryPickerViewController.swift
//  MyLocations
//
//  Created by Sebastien Arbogast on 05/09/2016.
//  Copyright © 2016 BusinessTraining. All rights reserved.
//

import UIKit

protocol CategoryPickerViewControllerDelegate: class {
    func categoryPickerViewController(controller:CategoryPickerViewController, didSelectCategory:String)
}

class CategoryPickerViewController: UITableViewController {
    
    let categories = [
        "No Category",
        "Bar",
        "Restaurant",
        "Club",
        "Store",
        "House",
        "Park",
        "Pokestop"
    ]
    
    var selectedCategoryName = ""
    var selectedIndexPath:NSIndexPath?
    weak var categoryPickerViewControllerDelegate:CategoryPickerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        updateSelectedIndexPath()
    }
    
    func updateSelectedIndexPath() {
        for i in 0..<categories.count {
            if categories[i] == selectedCategoryName {
                selectedIndexPath = NSIndexPath(forRow: i, inSection: 0)
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PickedCategory" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPathForCell(cell) {
                selectedCategoryName = categories[indexPath.row]
            }
        }
    }
}

//UITableViewDataSource implementation
extension CategoryPickerViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)
     
        let categoryName = categories[indexPath.row]
        cell.textLabel!.text = categoryName
        
        if indexPath == selectedIndexPath {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
     
        return cell
    }
}

//UITableViewDelegate implementation
extension CategoryPickerViewController {
    /*override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath != selectedIndexPath {
            let oldSelection = self.selectedIndexPath
            
            self.selectedIndexPath = indexPath
            selectedCategoryName = categories[indexPath.row]
            var toUpdate = [indexPath]
            if let oldSelection = oldSelection {
                toUpdate.insert(oldSelection, atIndex: 0)
            }
            tableView.reloadRowsAtIndexPaths(toUpdate, withRowAnimation: .Fade)
            
            if let delegate = categoryPickerViewControllerDelegate {
                delegate.categoryPickerViewController(self, didSelectCategory: self.selectedCategoryName)
            }
        } else {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }*/
}
