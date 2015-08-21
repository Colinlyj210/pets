//
//  UpdateTableViewController.swift
//  宠物管家
//
//  Created by lyj on 15/8/10.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit

class UpdateTableViewController: UITableViewController {
    var cells = [updateTableViewCell]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //定义每个cell并放到cells数组中,因为重用会发生不可知的错误,所以只能先定义好
        for _ in 0..<UpdateData.titiles.count{
            let cell = tableView.dequeueReusableCellWithIdentifier("updatecell") as! updateTableViewCell
            cells.append(cell)
        }
        //定义右按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target:self, action: "doneClick")
        
    }
    //右按钮点击事件
    func doneClick(){
        for var i = 0 ; i < cells.count; i++ {
            for b in cells[i].btn {
                if b.selected{
                    //遍历每个按钮,如果被选择了,就取它的tag放到数据数组中
                    UpdateData.fenshu[i] = b.tag
                }
            }
        }
        /**待写入数据库sqlite*/
        var sum = 0
        for a in UpdateData.fenshu{
             sum += a
        }
        print(sum)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UpdateData.titiles.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //定义每个cell中的标题
        cells[indexPath.row].title.text = UpdateData.titiles[indexPath.row]
        for var i = 0 ;i < 3; i++ {
            //定义每个按钮的标题
            cells[indexPath.row].btn[i].setTitle(UpdateData.btnTitles[indexPath.row][i], forState: UIControlState.Normal)
        }
        return cells[indexPath.row]
    }
    
}
