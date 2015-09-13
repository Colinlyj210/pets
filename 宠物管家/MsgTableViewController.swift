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
class MsgTableViewController: UITableViewController ,HZPhotoBrowserDelegate , XActionSheetDelegate,DoImagePickerControllerDelegate{

    var menu :PopMenu!
    var head : XHPathCover!
    var page = 2
    var msgData = [MsgInfo]()    // 一开始默认是空数组
    //添加按钮,弹出popmenu
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
        menu.menuAnimationType = PopMenuAnimationType.Sina//设置为新浪模式,还有网易模式可以设置
        //对应按钮点击事件
        menu.didSelectedItemCompletion = { (selectitem :MenuItem!) -> Void in
            print(selectitem.title)
            self.tabBarController?.tabBar.hidden = false
            //这里暂时都设置为跳转到发送消息界面
            switch selectitem.index{
            case 0:
                self.performSegueWithIdentifier("tosendmsg", sender: self)
                print(selectitem.index)
            case 1:
                self.performSegueWithIdentifier("tosendmsg", sender: self)
                print(selectitem.index)
            case 2:
                self.performSegueWithIdentifier("tosendmsg", sender: self)
                print(selectitem.index)
            default:
                break
            }
            
        }
        menu.showMenuAtView(self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()//设置没有cell的地方为空白
        //上拉加载更多
        self.tableView.addGifFooterWithRefreshingTarget(self, refreshingAction: "footRefresh")
        //下拉刷新
        head = XHPathCover(frame: CGRectMake(0, 0, self.view.frame.width , 220))
        head.setBackgroundImage(UIImage(named: "BG"))//背景
        head.setAvatarImage(UIImage(named: "touxiang"))//头像
        head.isZoomingEffect = true//下拉模糊设置
        //简要信息,将用户的昵称和个性签名显示在该界面
        head.setInfo(NSDictionary(objects: [UserInfo.uname,UserInfo.usign], forKeys: [XHUserNameKey,XHBirthdayKey]) as [NSObject : AnyObject])
        head.avatarButton.layer.cornerRadius = 33;
        head.avatarButton.layer.masksToBounds = true
        head.avatarButton.addTarget(self, action: "PhotoBrowse", forControlEvents: UIControlEvents.TouchUpInside)

        //设置下拉事件
        head.handleRefreshEvent = {
            self.headRefresh()
        }
        self.tableView.tableHeaderView = head;
    }
    //延时闭包
    func Delay(time:Double,closure:()->()){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    //下拉刷新
    func headRefresh(){
        ProgressHUD.show("亲爱的，别急嘛～～～")
        self.Delay(0.5) { () -> () in
            self.refresh(1)
            self.page = 2//刷新的时候重新设置pageNum
            self.flag = false//属性的时候重置flag
            self.head.stopRefresh()
            ProgressHUD.showSuccess("人家准备好了！")
        }
    }
    var flag = false//设置一个是否还有信息的标签
    func footRefresh(){
        ProgressHUD.show("还有更多内容")
        self.Delay(0.5) { () -> () in
            self.refresh(self.page)
            if self.flag {
                self.tableView.footer.endRefreshing()
                ProgressHUD.show("暂时没有更多内容")
                //增加延时取消HUD
                self.Delay(0.8, closure: { () -> () in
                    ProgressHUD.dismiss()
                })
                return
            }
            self.page++
            self.tableView.footer.endRefreshing()
            ProgressHUD.showSuccess("好了啦～～")
        }
        
    }

    func PhotoBrowse(){

        let action = XActionSheet()
        action.delegate = self
        action.addCancelButton("取消")
        action.addButtonwithTitle("拍照")
        action.addButtonwithTitle("相册")
        action.addButtonwithTitle("查看高清大图")
        
        self.presentViewController(action, animated: true) { () -> Void in
        }
    }
    func buttonClick(index: Int) {
        switch index{
        case 0:
            print("paizhao")
        case 1:
            let picker = DoImagePickerController(nibName: "DoImagePickerController", bundle: nil)
            picker.delegate = self
            picker.nMaxCount = 1
            picker.nColumnCount = 4
            self.presentViewController(picker, animated: true, completion: nil)
            
        case 2:
            let photobrowsevc = HZPhotoBrowser()
            photobrowsevc.sourceImagesContainerView = head.avatarButton
            photobrowsevc.imageCount = 1
            photobrowsevc.currentImageIndex = 0
            photobrowsevc.delegate = self
            photobrowsevc.show()
        default:
            break
        }
    }
    func didCancelDoImagePickerController() {
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    func didSelectPhotosFromDoImagePickerController(picker: DoImagePickerController!, result aSelected: [AnyObject]!) {
        let image = aSelected.first as! UIImage
        head.avatarButton.setImage(image, forState: UIControlState.Normal)
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    func photoBrowser(browser: HZPhotoBrowser!, placeholderImageForIndex index: Int) -> UIImage! {
        return head.avatarButton.currentImage
    }
    func photoBrowser(browser: HZPhotoBrowser!, highQualityImageURLForIndex index: Int) -> NSURL! {
        
        return NSURL(string: "http://www.lyj210.cn/pic.JPG")
    }
    
    //界面出现之后开始获取数据
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refresh(1)
        self.tabBarController?.tabBar.hidden = false
    }
    func refresh(pageNum: Int){
        // 因为异步调用 所以 可以直接写
        Pitaya.request(.GET, url: "http://www.lyj210.cn/cwgj/index.php/Home/Msg/selectMsg",params: ["page":pageNum] , errorCallback: { (error) -> Void in
            print("数据获取失败")
            }) { (data, response, error) -> Void in
                let json = JSON(data: data!)
                //如果为空这设置flag=true,没有信息,并返回
                if json.isEmpty {
                    self.flag = true
                    return
                }
                print(json)
                if pageNum == 1{//如果是刷新状态置空空msgData数组
                    self.msgData = []
                }
                //解析json数据
                for var i = 0 ; i < json.count ; i++ {
                    let username = json[i]["username"]
                    let time = json[i]["time"]
                    let msg = json[i]["msg"]
                    self.msgData.append(MsgInfo(userImg: "touxiang", userName: "\(username)", time: "\(time)", contentText: "\(msg)"))
                    //获取到数据 主线程更新UI
                    dispatch_async(dispatch_get_main_queue()){
                        self.tableView.reloadData()
                    }
                }
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //切换页面的时候把popmenu取消
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
        //自定义cell.并赋值
        let info = self.msgData[indexPath.row]
        cell.msgInfo = info
        return cell
    }
    //下面4个为head的操作
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
