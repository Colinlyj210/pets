
//
//  HomeTableViewController.swift
//  宠物管家
//
//  Created by lyj on 15/8/7.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit
import Charts
class HomeTableViewController: UITableViewController,ChartViewDelegate {

    @IBAction func updateBtn(sender: AnyObject) {
        self.toUpdateView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        /**
        SweetAlert().showAlert("是否更新宠物信息?", subTitle: "你将跳转到下个界面进行输入信息!", style: AlertStyle.Warning, buttonTitle:"取消!", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "确定", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == false {
                self.toUpdateView()
            }
        }
        */
        
        
        self.tableView.tableFooterView = UIView()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.hidden = false
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
        return 400
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("homecell", forIndexPath: indexPath)
        cell.textLabel?.text = "这是第\(indexPath.row)行"
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("\(indexPath.row)")
    }
    
    
    
    

    func healthChart()->UIView{
        let pie = PieChartView()
        pie.delegate = self
        pie.usePercentValuesEnabled = true //使用百分比值
        pie.holeTransparent = true //中心洞孔透明
        pie.centerTextFont = UIFont(name: "HelveticaNeue-Light", size: 12)!  //设置字体
        pie.holeRadiusPercent = 0.58//中心洞孔半径比例为0.58
        pie.transparentCircleRadiusPercent = 0.61 //透明圆半径比例
        pie.descriptionText = ""//描述
        pie.drawCenterTextEnabled = true //画中心文字
        pie.drawHoleEnabled = true
        pie.rotationAngle = 0//旋转角度
        pie.rotationEnabled = true //是否可旋转
        pie.centerText = "宠物健康信息"
        
        let legend = pie.legend //图表标题
        legend.position =  ChartLegend.ChartLegendPosition.RightOfChart//位置
        legend.xEntrySpace = 7
        legend.yEntrySpace = 0
        legend.yOffset = 0
        
        pie.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: ChartEasingOption.EaseOutBack)
        
        return pie
    }
    
    
  /**  func eatChart()->UIView{
        let lineChart = PNLineChart(frame: CGRectMake(0, 0, self.view.frame.width , 200))
        let xlab = ["sep1","sep2","sep3","sep4","sep5"];
        lineChart.setXLabels(xlab, withWidth: 60)
        let dataArr = [60.1,160.1,126.4,262.2,26.4]
        let data = PNLineChartData()
        data.color = UIColor.greenColor()
        data.itemCount = UInt(xlab.count)
        //data.getData = {()->()}
        
        data.getData = {(index: UInt) -> PNLineChartDataItem in
            let yValue: CGFloat = CGFloat(dataArr[Int(index)])
            return PNLineChartDataItem(y: yValue)
        }
        lineChart.chartData = [data]
        lineChart.strokeChart()
        return lineChart
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

 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toUpdate"{
            self.hidesBottomBarWhenPushed = true
            self.tabBarController?.tabBar.hidden = true
        }
        
    }
    

}
