//
//  SendMsgViewController.swift
//  宠物管家
//
//  Created by lyj on 15/8/24.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit
import Pitaya
class SendMsgViewController: UIViewController {
    @IBOutlet weak var contentTxt: UITextField!

    @IBAction func sendBtn(sender: AnyObject) {
        Pitaya.request(.POST, url: "http://www.lyj210.cn/cwgj/index.php/Home/Msg/addMsg", params: ["userName":"zxvv","content":contentTxt.text!], errorCallback: { (error) -> Void in
            print("出错了")
            }) { (data, response, error) -> Void in
                
                if data != nil{
                    
                    self.navigationController?.popViewControllerAnimated(true)
                }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
