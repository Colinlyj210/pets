//
//  UpdateTableViewController.swift
//  宠物管家
//
//  Created by lyj on 15/8/10.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit

class UpdateTableViewController: UITableViewController {
    var selectTag = [Int]()
    var cells = [updateTableViewCell]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedRowHeight = 100
        
        for _ in 0..<10{
            selectTag.append(1)
            let cell = tableView.dequeueReusableCellWithIdentifier("updatecell") as! updateTableViewCell
            cells.append(cell)
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UpdateData.titiles.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        cells[indexPath.row].title.text = UpdateData.titiles[indexPath.row]
        for var i = 0 ;i < 3; i++ {
            cells[indexPath.row].btn[i].setTitle(UpdateData.btnTitles[indexPath.row][i], forState: UIControlState.Normal)
        }
        
        
        return cells[indexPath.row]
    }
    

}
