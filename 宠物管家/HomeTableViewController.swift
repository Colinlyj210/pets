
//
//  HomeTableViewController.swift
//  宠物管家
//
//  Created by lyj on 15/8/7.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    @IBAction func updateBtn(sender: AnyObject) {
        self.toUpdateView()
        for i in UpdateData.skill{
            print(i)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "主页"
        self.view.backgroundColor = UIColor(hex: "8CA2C2")

        SweetAlert().showAlert("是否更新宠物信息?", subTitle: "你将跳转到下个界面进行输入信息!", style: AlertStyle.Warning, buttonTitle:"取消!", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "确定", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == false {
                self.toUpdateView()
            }
        }

        self.tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func toUpdateView(){
        self.performSegueWithIdentifier("toUpdate", sender: self)
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
            return self.view.frame.width + 200
        case 1:
            return 430
        case 2:
            return 400
        case 3:
            return 350
        default:
            return 400
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("homecell", forIndexPath: indexPath)
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        switch indexPath.row{
        case 0:
            let tlab = UILabel(frame: CGRectMake(50, 40, 200, 30))
            tlab.text = "宠物综合得分"
            tlab.textColor = UIColor.whiteColor()
            cell.contentView.addSubview(tlab)
            let lab = UILabel(frame: CGRectMake(self.view.frame.width/2 - 100, 50, 200, 200))
            lab.text = "\(UpdateData.queryAllScoreData())"
            lab.textColor = UIColor.whiteColor()
            lab.textAlignment = NSTextAlignment.Center
            lab.font = UIFont(name: "Arial", size: 100)
            cell.contentView.addSubview(lab)
            cell.contentView.addSubview(spiderChart(CGRectMake(50, 250, self.view.frame.width - 100, self.view.frame.width - 100)))
        case 1:
            cell.contentView.addSubview(healthChart(CGRectMake(0, 0, self.view.frame.width, 400)))
        case 2:
            let w = self.view.frame.width - 150
            cell.contentView.addSubview(cleanChart(CGRectMake(0, 0,self.view.frame.width ,400),w: w))
        case 3:
            let s = BtnCellView()
            s.frame = CGRectMake(50, 50, self.view.frame.width - 100, 250)
            s.backgroundColor = UIColor.clearColor()
            cell.contentView.addSubview(s)
        default:
            let lab = UILabel(frame: CGRectMake(0, 0, 100, 30))
            lab.text = "\(indexPath.row)"
            cell.contentView.addSubview(lab)
        }
        cell.backgroundColor = UIColor(hex: "8CA2C2")
        return cell
    }
    
    func spiderChart(frame: CGRect)->UIView{
        let va = UpdateData.queryspiderData()
        let value = ["健康": "\(va[0])","清洁": "\(va[1])","不饥饿": "\(va[2])","技能": "\(va[3])","综合得分": "\(va[4])"]
        let spide = BTSpiderPlotterView(frame: frame, valueDictionary: value)
        spide.maxValue = 5
        spide.drawboardColor = UIColor.whiteColor()
        spide.plotColor = UIColor(red: 227/256, green: 166/256, blue: 167/256, alpha: 0.85)
        spide.animateWithDuration(1, valueDictionary: value)
        return spide
    }
    
    func cleanChart(frame: CGRect,w: CGFloat)->UIView{
        let uiview  = UIView(frame: frame)
        let cicleChart = PNCircleChart(frame: CGRectMake(75, 50,w ,w), total: 100, current: UpdateData.querycleanData(), clockwise: false, shadow: false, shadowColor: UIColor.lightGrayColor())
        cicleChart.backgroundColor = UIColor.clearColor()
        cicleChart.strokeColor = UIColor.greenColor()
        cicleChart.lineWidth = w/15
        cicleChart.strokeChart()
        uiview.addSubview(cicleChart)

        let lab = UILabel(frame: CGRectMake(30, 330, self.view.frame.width - 60, 50))
        lab.text = "您的宠物已经很久没洗澡了,都长虫子了"
        lab.textColor  = UIColor.whiteColor()
        lab.lineBreakMode = NSLineBreakMode.ByWordWrapping//这两行实现label换行
        lab.numberOfLines = 0
        lab.sizeToFit()
        uiview.addSubview(lab)
        
        return uiview
        
    }

    func healthChart(frame: CGRect)->UIView{
        let uiview = UIView(frame: frame)
        var xlab = [String]()
        var dataArr = [Int]()
        let da = UpdateData.queryhealthData()
        for var i = da.count; i > 0 ; i-- {
            dataArr.append(da[i-1])
        }
        for var i = 0 ; i < dataArr.count; i++ {
            xlab.append("第\(i + 1)天")
        }

        let lineChart = PNLineChart(frame: CGRectMake(0, 25, self.view.frame.width , 300))

        lineChart.setXLabels(xlab, withWidth: self.view.frame.width/5 - 15)
        let data = PNLineChartData()
        data.color = UIColor.greenColor()
        data.itemCount = UInt(xlab.count)
        
        data.getData = {(index: UInt) -> PNLineChartDataItem in
            let yValue: CGFloat = CGFloat(dataArr[Int(index)])
            return PNLineChartDataItem(y: yValue)
        }
        lineChart.chartData = [data]
        lineChart.strokeChart()
        lineChart.backgroundColor = UIColor.clearColor()
        uiview.addSubview(lineChart)
        
        let label = UILabel(frame: CGRectMake(30, 350, self.view.frame.width - 60, 70))
        label.text = UpdateData.description[1]
        label.textColor  = UIColor.whiteColor()
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping//这两行实现label换行
        label.numberOfLines = 0
        label.sizeToFit()
        uiview.addSubview(label)
        return uiview
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toUpdate"{
            self.hidesBottomBarWhenPushed = true
            self.tabBarController?.tabBar.hidden = true
        }
        
    }
    

}
