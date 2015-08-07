
//
//  HomeTableViewController.swift
//  宠物管家
//
//  Created by lyj on 15/8/7.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
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
        return 5
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 400
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("homecell", forIndexPath: indexPath)
        switch indexPath.row {
        case 0:
            cell.contentView.addSubview(healthChart())
        case 1:
            cell.contentView.addSubview(eatChart())
        case 2:
            cell.textLabel?.text = "\(indexPath.row)"
        case 3:
            cell.textLabel?.text = "\(indexPath.row)"
        case 4:
            cell.textLabel?.text = "\(indexPath.row)"
        default:
            break
        }
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("\(indexPath.row)")
    }
    func healthChart()->UIView{
        let items = [PNPieChartDataItem(value: 10 , color: UIColor.redColor()),PNPieChartDataItem(value: 20, color: UIColor.blueColor(), description: "abc"),PNPieChartDataItem(value: 40, color: UIColor.greenColor(), description: "123")]
        let pie = PNPieChart(frame: CGRectMake(self.view.bounds.width/2 - 100, 100, 200, 200), items: items)
        pie.descriptionTextColor = UIColor.whiteColor()
        pie.descriptionTextFont = UIFont(name: "Avenir-Medium", size: 14)
        pie.strokeChart()
        return pie
    }
    func eatChart()->UIView{
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
//        // Line Chart No.2
//        NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2];
//        PNLineChartData *data02 = [PNLineChartData new];
//        data02.color = PNTwitterColor;
//        data02.itemCount = lineChart.xLabels.count;
//        data02.getData = ^(NSUInteger index) {
//            CGFloat yValue = [data02Array[index] floatValue];
//            return [PNLineChartDataItem dataItemWithY:yValue];
//        };
//        
//        lineChart.chartData = @[data01, data02];
//        [lineChart strokeChart];
        
        
        return lineChart
    }
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
