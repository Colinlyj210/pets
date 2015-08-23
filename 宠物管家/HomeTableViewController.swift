
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
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "主页"
        self.view.backgroundColor = UIColor(hex: "8CA2C2")
        //self.tableView.backgroundColor = UIColor(hex: "8CA2C2")
        /**
        SweetAlert().showAlert("是否更新宠物信息?", subTitle: "你将跳转到下个界面进行输入信息!", style: AlertStyle.Warning, buttonTitle:"取消!", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "确定", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == false {
                self.toUpdateView()
            }
        }
        */
        
        
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
        // Dispose of any resources that can be recreated.
    }
    func toUpdateView(){
        self.performSegueWithIdentifier("toUpdate", sender: self)
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 450
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("homecell", forIndexPath: indexPath)
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if indexPath.row == 0{
            cell.contentView.addSubview(healthChart())
        }else if indexPath.row == 1{
            cell.contentView.addSubview(cleanChart())
        }else if indexPath.row == 2{
            cell.contentView.addSubview(spiderChart())
        }else if indexPath.row == 3{
            cell.contentView.addSubview(petSkill())
        }
        
        
        else{
            let lab = UILabel(frame: CGRectMake(0, 0, 100, 30))
            lab.text = "\(indexPath.row)"
            cell.contentView.addSubview(lab)
        }
        cell.backgroundColor = UIColor(hex: "8CA2C2")
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("\(indexPath.row)")
    }
    func petSkill()->UIView{
        let uiview = UIView(frame: CGRectMake(50, 50, self.view.frame.width - 100, 400))
        let btn = UIButton(frame: CGRectMake(0, 0, 100, 30))
        btn.setTitle("自己吃饭", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
        btn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.lightGrayColor()
        btn.addTarget(self, action: "petskillclick:", forControlEvents: UIControlEvents.TouchUpInside)
        uiview.addSubview(btn)
        
        
        return uiview
    }
    func petskillclick(btn: UIButton){
        if btn.selected{
            btn.selected = false
            btn.backgroundColor = UIColor.lightGrayColor()
        }else{
            btn.selected = true
            btn.backgroundColor = UIColor.blueColor()
        }
        
        
        
    }
    func spiderChart()->UIView{
        let value = ["健康": "3.3","清洁": "5.0","不饥饿": "4.5","技能": "2.2","综合得分": "4.0"]
        let width = self.view.frame.width - 100
        let spide = BTSpiderPlotterView(frame: CGRectMake(50, 50, width, width), valueDictionary: value)
        spide.maxValue = 5
        spide.drawboardColor = UIColor.whiteColor()
        spide.plotColor = UIColor(red: 227/256, green: 166/256, blue: 167/256, alpha: 0.85)
        spide.animateWithDuration(1, valueDictionary: value)
        return spide
        
    }
    
    func cleanChart()->UIView{
        let width = self.view.frame.width - 150
        let cicleChart = PNCircleChart(frame: CGRectMake(75, 50, width, width), total: 100, current: 80, clockwise: false, shadow: false, shadowColor: UIColor.lightGrayColor())
        cicleChart.backgroundColor = UIColor.clearColor()
        cicleChart.strokeColor = UIColor.greenColor()
        cicleChart.lineWidth = width/15
        cicleChart.strokeChart()
        return cicleChart
        
    }

    func healthChart()->UIView{
        let uiview = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 400))
        //uiview.backgroundColor = UIColor(hex: "8CA2C2")
        var xlab = [String]()
        var dataArr = [1,1,1,1,1]
        let scArr = Score.selectWhere(nil, groupBy: nil, orderBy: "hostID desc", limit: "5") as! [Score]
        print(scArr.count)
        if scArr.count == 0{
            return UIView(frame: CGRectMake(0, 0, self.view.frame.width , 300))
        }
        for var i = 0 ; i < scArr.count; i++ {
            dataArr[i] = Int(scArr[scArr.count - i - 1].feshu)!
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
