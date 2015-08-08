//
//  LoginViewController.swift
//  宠物管家
//
//  Created by lyj on 15/8/8.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit
class LoginViewController: UIViewController {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPwd: UITextField!
    @IBAction func loginBtn(sender: AnyObject) {
        let Id = userName.text!
        let Pwd = userPwd.text!
//        Pitaya.request(.POST, url: "http://www.lyj210.cn/cwgj/index.php/Home/Index/selectUser", params: ["uid":userId, "upwd":userPwd], errorCallback: { (error) -> Void in
//            print("出错了")
//            }) { (data, response, error) -> Void in
//                let json = JSON(data: data!)
//                if json["state"] == 1{
//                    print("登陆成功")
//                    self.performSegueWithIdentifier("login", sender: self)
//                }else{
//                    print("登陆失败")
//                }
//        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
