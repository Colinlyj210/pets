//
//  PetsTableViewController.swift
//  宠物管家
//
//  Created by lyj on 15/8/7.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit
import Pitaya
class PetsTableViewController: UITableViewController,SDCycleScrollViewDelegate {
    @IBOutlet weak var uiscview: UIView!
    var readData = [ReadInfo]()//数据源数组
    var page = 2//控制下拉第几页
    var urlStr = ""//定义传到web界面的值

    let arr = ["http://www.lyj210.cn/cwgj/pic/huli/huli.jpg","http://www.lyj210.cn/cwgj/pic/siyang/siyang.jpg","http://www.lyj210.cn/cwgj/pic/xunlian/xunlian.jpg"]

    let ss = ["宠物疾病篇","宠物吃饭篇","宠物训练篇"]

    override func viewDidLoad() {
        super.viewDidLoad()

        SDImageCache.sharedImageCache().cleanDisk()//清除硬盘中的缓存
        SDImageCache.sharedImageCache().clearMemory()//清除内存中的缓存
        
        self.tableView.tableFooterView = UIView()//去掉没数据的空行
        //添加下拉刷新
        self.tableView.addLegendHeaderWithRefreshingTarget(self, refreshingAction: "headRefresh")
        //添加上拉加载
        self.tableView.addGifFooterWithRefreshingTarget(self, refreshingAction: "footRefresh")
        //定义滚动条
        let sc = SDCycleScrollView(frame:uiscview.frame, imageURLStringsGroup: nil)
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            sc.imageURLStringsGroup = self.arr//异步获取图片数组
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
        Delay(0.5) { () -> () in
            self.getData2(1)
            self.page = 2//属性状态下重置page
            self.flag = false
            self.tableView.header.endRefreshing()
            ProgressHUD.showSuccess("人家准备好了～～")
        }
    }
    var flag = false
    func footRefresh(){
        //上拉加载
        ProgressHUD.show("还有更多内容")
        self.Delay(0.5, closure: { () -> () in
            self.getData2(self.page)
            if self.flag {
                self.tableView.footer.endRefreshing()
                ProgressHUD.show("暂时没有更多内容")
                //增加延时取消HUD
                self.Delay(0.8, closure: { () -> () in
                    ProgressHUD.dismiss()
                })
                return
            }
            self.page++ //下拉状态每次page+1
            self.tableView.footer.endRefreshing()
            ProgressHUD.showSuccess("好了啦～～")
        })
        
    }
    //模拟网络数据加载延迟.为演示HUD效果进行延时操作
    func Delay(time:Double,closure:()->()){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        //滚动条点击的图片,并执行相应的动作
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
        getData2(1)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readData.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //定义传到web界面的url值
        self.urlStr = readData[indexPath.row].cellUrl
        performSegueWithIdentifier("cellToweb", sender: self)
    }
    func getData2(numPage: Int){
        
        //获取网络数据
        Pitaya.request(.GET, url: "http://www.lyj210.cn/cwgj/index.php/Home/Read/selectRead2", params: ["page":numPage], errorCallback: { (error) -> Void in
            print("出错了")
            }) { (data, response, error) -> Void in
                let json = JSON(data: data!)
                print(json)
                //如果为空这设置flag=true,没有信息,并返回
                if json.isEmpty {
                    self.flag = true
                    return
                }
                if numPage == 1 {
                    self.readData = []//刷新状态置空数据源数组
                }
                for var i = 0; i < json.count ; i++ {
                    let imgurl = json[i]["imgurl"]
                    let celltitle = json[i]["celltitle"]
                    let urlstr = json[i]["urlstr"]
                    //json解析并添加到数据源数组
                    self.readData.append(ReadInfo(cellImgUrl: "\(imgurl)", cellTitle: "\(celltitle)", cellUrl: "\(urlstr)"))
                    dispatch_async(dispatch_get_main_queue()){
                        self.tableView.reloadData()
                    }
                
                }
                
            }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ReadTableViewCell
        print("---------\(indexPath.row)")
        let info = readData[indexPath.row]
        cell.readInfo = info//cell内容赋值
        return cell
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //cell显示动画效果
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    //跳转到web界面
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.hidesBottomBarWhenPushed = true
        self.tabBarController?.tabBar.hidden = true
        let web = segue.destinationViewController as! WebViewController
        web.url = self.urlStr
        
    }
    

}
