//
//  MsgTableViewController.swift
//  宠物管家
//
//  Created by lyj on 15/8/9.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit

class MsgTableViewController: UITableViewController {
    var menu :PopMenu!
    @IBAction func addBtn(sender: AnyObject) {
        let items = [
            MenuItem(title: "face", iconName: "post_type_bubble_facebook", glowColor: UIColor.redColor(),index: 0),
            MenuItem(title: "tsobao", iconName: "post_type_bubble_flickr", glowColor: UIColor.blueColor(),index: 1),
            MenuItem(title: "sina", iconName: "post_type_bubble_googleplus", glowColor: UIColor.yellowColor(),index: 2)
        ]
        //self.tabBarController?.tabBar.hidden = true
        
        menu = PopMenu(frame: self.view.bounds, items: items)
        menu.menuAnimationType = PopMenuAnimationType.Sina
        if menu.isShowed{
            menu.removeFromSuperview()
            return
        }
        menu.didSelectedItemCompletion = { (selectitem :MenuItem!) -> Void in
            print(selectitem.title)
            self.tabBarController?.tabBar.hidden = false
            switch selectitem.index{
            case 0:
                print(selectitem.index)
            case 1:
                print(selectitem.index)
            case 2:
                print(selectitem.index)
            default:
                break
            }
            
        }
        //menu.removeFromSuperview()
        menu.showMenuAtView(self.view)
        
    }
    var data = [String]()
    var i = 0
    var head : XHPathCover!
    override func viewDidLoad() {
        super.viewDidLoad()

        for a in 0...9{
            self.i = a
            data.append("\(a)")
        }
        self.tableView.tableFooterView = UIView()
        //上拉加载更多
        self.tableView.addGifFooterWithRefreshingTarget(self, refreshingAction: "footRefresh")
        //下拉刷新
        head = XHPathCover(frame: CGRectMake(0, 0, self.view.frame.width , 240))
        head.setBackgroundImage(UIImage(named: "BG"))
        head.setAvatarImage(UIImage(named: "IMG_0755"))
        head.isZoomingEffect = true//下拉模糊设置
        head.setInfo(NSDictionary(objects: ["落幕","ios工程师"], forKeys: [XHUserNameKey,XHBirthdayKey]) as [NSObject : AnyObject])
        
        head.avatarButton.layer.cornerRadius = 33;
        head.avatarButton.layer.masksToBounds = true
        head.handleRefreshEvent = {
            self.headRefresh()
        }
        self.tableView.tableHeaderView = head;
        
    }

    func headRefresh(){
        //ProgressHUD.show("亲爱的，别急嘛～～～")
        self.Delay(2, closure: { () -> () in
            self.data.removeAll(keepCapacity: false)
            self.i = 0
            for self.i ; self.i < 10 ; self.i++ {
                self.data.append("\(self.i)")
            }
            //self.tableView.header.endRefreshing()
            self.tableView.reloadData()
            //ProgressHUD.showSuccess("人家准备好了！")
            self.head.stopRefresh()
        })
    }
    func Delay(time:Double,closure:()->()){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    func footRefresh(){
        //ProgressHUD.show("还有更多内容")
        self.Delay(2, closure: { () -> () in
            let j = self.i + 10
            for self.i ; self.i < j ; self.i++ {
                self.data.append("\(self.i)")
            }
            self.tableView.footer.endRefreshing()
            self.tableView.reloadData()
//ProgressHUD.showSuccess("好了啦～～")
        })
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if menu != nil{
            self.menu.dismissMenu()
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
        return data.count
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("msgcell", forIndexPath: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        // Configure the cell...
        
        return cell
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        head.scrollViewDidScroll(scrollView)
    }
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        head.scrollViewDidEndDecelerating(scrollView)
    }
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        head.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        head.scrollViewWillBeginDragging(scrollView)
    }


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
