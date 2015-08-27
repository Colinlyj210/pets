//
//  MsgTableViewController.swift
//  宠物管家
//
//  Created by lyj on 15/8/9.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit
import Pitaya
extension String {
    
    var lastPathComponent: String {
        
        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
        
        get {
            
            return (self as NSString).pathExtension
        }
    }
    var stringByDeletingLastPathComponent: String {
        
        get {
            
            return (self as NSString).stringByDeletingLastPathComponent
        }
    }
    var stringByDeletingPathExtension: String {
        
        get {
            
            return (self as NSString).stringByDeletingPathExtension
        }
    }
    var pathComponents: [String] {
        
        get {
            
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(ext: String) -> String? {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathExtension(ext)
    }
}
class MsgTableViewController: UITableViewController {
    var menu :PopMenu!
    var head : XHPathCover!
    var page = 2
    var msgData = [MsgInfo]()    // 一开始默认是空数组
    @IBAction func addBtn(sender: UIBarButtonItem) {
        let items = [
            MenuItem(title: "文字", iconName: "edit", glowColor: UIColor(hex: "FA386C"),index: 0),
            MenuItem(title: "相册", iconName: "photo", glowColor: UIColor.orangeColor(),index: 1),
            MenuItem(title: "照片", iconName: "camera", glowColor: UIColor.yellowColor(),index: 2)
        ]
        if menu != nil&&menu.isShowed{
            print("menu is showed")
            menu.dismissMenu()
            return
        }

        
        menu = PopMenu(frame: self.view.bounds, items: items)
        menu.menuAnimationType = PopMenuAnimationType.Sina

        menu.didSelectedItemCompletion = { (selectitem :MenuItem!) -> Void in
            print(selectitem.title)
            self.tabBarController?.tabBar.hidden = false
            switch selectitem.index{
            case 0:

                self.performSegueWithIdentifier("tosendmsg", sender: self)
                print(selectitem.index)
            case 1:
                print(selectitem.index)
            case 2:
                print(selectitem.index)
            default:
                break
            }
            
        }
        menu.showMenuAtView(self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        //上拉加载更多
        self.tableView.addGifFooterWithRefreshingTarget(self, refreshingAction: "footRefresh")
        //下拉刷新
        head = XHPathCover(frame: CGRectMake(0, 0, self.view.frame.width , 220))
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
    func Delay(time:Double,closure:()->()){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    func headRefresh(){
        ProgressHUD.show("亲爱的，别急嘛～～～")
        self.Delay(1) { () -> () in
            self.refresh(1)
            self.head.stopRefresh()
            ProgressHUD.showSuccess("人家准备好了！")
        }
    }

    func footRefresh(){
        ProgressHUD.show("还有更多内容")
        refresh(page)
        page++
        ProgressHUD.showSuccess("好了啦～～")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        
    }
    //界面出现之后开始获取数据
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refresh(1)
            }
    func refresh(pageNum: Int){
        // 因为异步调用 所以 可以直接写
        Pitaya.request(.GET, url: "http://www.lyj210.cn/cwgj/index.php/Home/Msg/selectMsg",params: ["page":pageNum] , errorCallback: { (error) -> Void in
            print("数据获取失败")
            }) { (data, response, error) -> Void in
                let json = JSON(data: data!)
                print(json)
                for var i = 0 ; i < json.count ; i++ {
                    let userimg = json[i]["userimg"]
                    let username = json[i]["username"]
                    let time = json[i]["time"]
                    let msg = json[i]["msg"]
                    self.msgData.append(MsgInfo(userImg: "IMG_0755", userName: "\(username)", time: "\(time)", contentText: "\(msg)"))
                    
                    //获取到数据 主线程更新UI
                    dispatch_async(dispatch_get_main_queue()){
                        self.tableView.reloadData()
                    }
                }
        }

    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if menu != nil{
            self.menu.dismissMenu()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("msgcell", forIndexPath: indexPath) as! MsgTableViewCell
        let info = self.msgData[indexPath.row]
        cell.msgInfo = info
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.hidesBottomBarWhenPushed = true
        self.tabBarController?.tabBar.hidden = true
    }

}
