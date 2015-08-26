//
//  PetsTableViewController.swift
//  宠物管家
//
//  Created by lyj on 15/8/7.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit

class PetsTableViewController: UITableViewController,SDCycleScrollViewDelegate {
    @IBOutlet weak var uiscview: UIView!
    var urlStr = ""
    var objArray = [String]()
    var i = 0
    let arr = ["http://www.lyj210.cn/cwgj/pic/huli/huli.jpg","http://www.lyj210.cn/cwgj/pic/siyang/siyang.jpg","http://www.lyj210.cn/cwgj/pic/xunlian/xunlian.jpg"]
    let urls = ["http://v.xiumi.us/board/v3/25PvV/3524920","http://v.xiumi.us/board/v3/25PvV/3525027","http://v.xiumi.us/board/v3/25PvV/3525407","","","","","","",""]
    
    
    let ss = ["宠物疾病篇","宠物吃饭篇","宠物训练篇"]

    override func viewDidLoad() {
        super.viewDidLoad()
        SDImageCache.sharedImageCache().cleanDisk()//清除硬盘中的缓存
        SDImageCache.sharedImageCache().clearMemory()//清除内存中的缓存
        for i; i < 10;i++ {
            self.objArray.append("\(i)")
        }
        self.tableView.tableFooterView = UIView()//去掉没数据的空行
        //添加下拉刷新
        self.tableView.addLegendHeaderWithRefreshingTarget(self, refreshingAction: "headRefresh")
        //添加下拉加载

        self.tableView.addGifFooterWithRefreshingTarget(self, refreshingAction: "footRefresh")
        
        
        let sc = SDCycleScrollView(frame:uiscview.frame, imageURLStringsGroup: nil)
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            sc.imageURLStringsGroup = self.arr
        }
        
        sc.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        sc.titlesGroup = ss
        sc.delegate = self
        sc.autoScrollTimeInterval = 2
        //cycleScrollView2.dotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
        sc.placeholderImage = UIImage(named: "h1")//网络图片未加载时显示图片h1
        self.uiscview.addSubview(sc)
    }
    func headRefresh(){
        //下拉刷新
        ProgressHUD.show("亲爱的别着急~~")
        Delay(1) { () -> () in
            self.objArray.removeAll(keepCapacity: false)
            self.i = 0
            for self.i ; self.i < 10 ; self.i++ {
                self.objArray.append("new\(self.i)")
            }
            self.tableView.header.endRefreshing()
            self.tableView.reloadData()
            ProgressHUD.showSuccess("人家准备好了～～")
        }
    }
    func footRefresh(){
        //上拉加载
        ProgressHUD.show("还有更多内容")
        self.Delay(1, closure: { () -> () in
            let j = self.i + 10
            for self.i ; self.i < j ; self.i++ {
                self.objArray.append("\(self.i)")
            }
            self.tableView.footer.endRefreshing()
            self.tableView.reloadData()
            ProgressHUD.showSuccess("好了啦～～")
        })
        
    }
    //模拟网络数据加载延迟
    func Delay(time:Double,closure:()->()){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        switch index {
        case 0:
            self.urlStr = "http://v.xiumi.us/board/v3/25PvV/2750964"
        case 1:
            self.urlStr = "http://v.xiumi.us/board/v3/25PvV/2760872"
        case 2:
            self.urlStr = "http://v.xiumi.us/board/v3/25PvV/2760848"
        default:
            break
        }
        performSegueWithIdentifier("cellToweb", sender: self)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objArray.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.urlStr = urls[indexPath.row]
        performSegueWithIdentifier("cellToweb", sender: self)
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        //self.urlStr = urls[indexPath.row]
        cell.textLabel?.text = self.objArray[indexPath.row]
        return cell
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.hidesBottomBarWhenPushed = true
        self.tabBarController?.tabBar.hidden = true
        let web = segue.destinationViewController as! WebViewController
        web.url = self.urlStr
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
