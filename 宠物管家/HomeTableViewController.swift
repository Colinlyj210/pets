
//
//  HomeTableViewController.swift
//  宠物管家
//
//  Created by lyj on 15/8/7.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    var taglist :GBTagListView!

    @IBAction func updateBtn(sender: AnyObject) {
        self.toUpdateView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if CoreFMDB.countTable("PetSkill") != 0{
            let petsk = PetSkill.selectWhere(nil, groupBy: nil, orderBy: nil, limit: nil) as! [PetSkill]
            for bb in petsk{
                PetSkills.petskills.append(bb.petskill)
                self.tableView.reloadData()
            }
        }
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
            return self.view.frame.width + 220
        case 1:
            return 400
        case 2:
            return 400
        case 3:
            return 350
        default:
            return 400
        }
    }
    //构建每一个cell内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("homecell", forIndexPath: indexPath)
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        switch indexPath.row{
        case 0:
            let allScore = UpdateData.queryAllScoreData()
            let tlab = UILabel(frame: CGRectMake(50, 40, 200, 30))
            tlab.text = "宠物综合得分"
            tlab.textColor = UIColor.whiteColor()
            cell.contentView.addSubview(tlab)
            let lab = UILabel(frame: CGRectMake(self.view.frame.width/2 - 100, 50, 200, 200))
            lab.text = "\(allScore)"
            lab.textColor = UIColor.whiteColor()
            lab.textAlignment = NSTextAlignment.Center
            lab.font = UIFont(name: "Arial", size: 100)
            cell.contentView.addSubview(lab)
            cell.contentView.addSubview(spiderChart(CGRectMake(50, 230, self.view.frame.width - 100, self.view.frame.width - 100)))
            let label = UILabel(frame: CGRectMake(30, 530, self.view.frame.width - 60, 70))
            if allScore >= 85{
                label.text = UpdateData.description[0]
            }else if allScore >= 60 && allScore < 85{
                label.text = UpdateData.description[1]
            }else if allScore < 60{
                label.text = UpdateData.description[2]
            }
            
            label.textColor  = UIColor.whiteColor()
            label.lineBreakMode = NSLineBreakMode.ByWordWrapping//这两行实现label换行
            label.numberOfLines = 0
            label.sizeToFit()
            cell.contentView.addSubview(label)
        case 1:
            cell.contentView.addSubview(self.cellTitle("宠物健康度"))
            cell.contentView.addSubview(healthChart(CGRectMake(0, 30, self.view.frame.width, 400)))
        case 2:
            cell.contentView.addSubview(self.cellTitle("宠物清洁度"))
            let w = self.view.frame.width - 150
            cell.contentView.addSubview(cleanChart(CGRectMake(0, 30,self.view.frame.width ,400),w: w))
        case 3:
            cell.contentView.addSubview(self.cellTitle("宠物技能"))
            let delbutton = UIButton(frame: CGRectMake(self.view.frame.width - 50, 30, 40, 20))
            delbutton.addTarget(self, action: "pskillClickdel", forControlEvents: UIControlEvents.TouchUpInside)
            delbutton.setTitle("删除", forState: UIControlState.Normal)
            cell.contentView.addSubview(delbutton)
            
            let addbutton = UIButton(frame: CGRectMake(10, 30, 40, 20))
            addbutton.addTarget(self, action: "pskillClickadd", forControlEvents: UIControlEvents.TouchUpInside)
            addbutton.setTitle("添加", forState: UIControlState.Normal)
            cell.contentView.addSubview(addbutton)
            taglist = GBTagListView(frame: CGRectMake(10,70,self.view.frame.width - 20 , 0))
            taglist.GBbackgroundColor = UIColor.clearColor()
            taglist.setTagWithTagArray(PetSkills.petskills)
            cell.contentView.addSubview(taglist)
        default:
            break
        }
        cell.backgroundColor = UIColor(hex: "8CA2C2")
        return cell
    }
    //cell标题
    func cellTitle(titleStr: String)->UILabel{
        let lab = UILabel(frame: CGRectMake(0, 20, self.view.frame.width, 20))
        lab.text = titleStr
        lab.textColor = UIColor.whiteColor()
        lab.textAlignment = NSTextAlignment.Center
        return lab
    }
    //删除宠物技能
    func pskillClickdel(){
        EYInputPopupView.popViewWithTitle("删除宠物技能", contentText: "", type: EYInputPopupView_Type_single_line_text, cancelBlock: { () -> Void in
            }, confirmBlock: { (view:UIView!, text:String!) -> Void in
                print(text)
                if text == nil || text == ""{
                    return
                }
                if !PetSkills.petskills.contains(text) {
                    ProgressHUD.showError("该技能不存在")
                    return
                }
                for i in 0..<PetSkills.petskills.count{
                    if PetSkills.petskills[i] == text {
                        print("找到了")
                        self.selectaa()
                        let pskl = PetSkill.selectWhere("petskill = '\(text)'", groupBy: nil, orderBy: nil, limit: nil) as! [PetSkill]
                        print(pskl[0].hostID)
                        
                        PetSkills.petskills.removeAtIndex(i)
                        if PetSkill.delete(UInt(pskl[0].hostID)){
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.tableView.reloadData()
                            })
                        }
                        return
                    }
                }
            }) { () -> Void in
        }
    }
    
    func selectaa(){
        let p = PetSkill.selectWhere(nil, groupBy: nil, orderBy: nil, limit: nil) as! [PetSkill]
        for i in 0..<p.count{
            print(p[i].hostID)
            print(p[i].petskill)
        }
        
    }
    //添加宠物技能
    var existnum = 1
    func pskillClickadd(){
        EYInputPopupView.popViewWithTitle("添加宠物技能", contentText: "", type: EYInputPopupView_Type_single_line_text, cancelBlock: { () -> Void in
            }, confirmBlock: { (view:UIView!, text:String!) -> Void in
                print(text)
                if text == nil || text == ""{
                    return
                }
                if PetSkills.petskills.contains(text) {
                    ProgressHUD.showError("该技能已存在")
                    return
                }
                //将宠物技能添加到数组中并写入数据库
                PetSkills.petskills.append(text)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //self.taglist.setTagWithTagArray(PetSkills.petskills)
                    self.tableView.reloadData()
                })
                let petsk = PetSkill()
                let pskl = PetSkill.selectWhere(nil, groupBy: nil, orderBy: nil, limit: nil) as! [PetSkill]
                if pskl.count != 0{
                    petsk.hostID = pskl[pskl.count - 1].hostID + 1
                }else{
                    petsk.hostID = 1
                }
    
                petsk.petskill = text
                PetSkill.save(petsk)

            }) { () -> Void in
        }
    }

    //构建蜘蛛网图
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
    //构建清洁度环形图
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
    //构建健康度折线图
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
        
//        let label = UILabel(frame: CGRectMake(30, 330, self.view.frame.width - 60, 70))
//        
//        label.text = UpdateData.description[1]
//        label.textColor  = UIColor.whiteColor()
//        label.lineBreakMode = NSLineBreakMode.ByWordWrapping//这两行实现label换行
//        label.numberOfLines = 0
//        label.sizeToFit()
//        uiview.addSubview(label)
        return uiview
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toUpdate"{
            self.hidesBottomBarWhenPushed = true
            self.tabBarController?.tabBar.hidden = true
        }
        
    }
    

}
