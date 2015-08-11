//
//  LoginViewController.swift
//  宠物管家
//
//  Created by lyj on 15/8/8.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit
import Pitaya
class LoginViewController: UIViewController,EAIntroDelegate {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPwd: UITextField!
    @IBAction func loginBtn(sender: AnyObject) {
        print("dianji")
        let Id = userName.text!
        let Pwd = userPwd.text!
        Pitaya.request(.POST, url: "http://www.lyj210.cn/cwgj/index.php/Home/Index/selectUser", params: ["uid":Id, "upwd":Pwd], errorCallback: { (error) -> Void in
            print("出错了")
            }) { (data, response, error) -> Void in
                let json = JSON(data: data!)
                if json["state"] == 1{
                    print("登陆成功")
                    self.performSegueWithIdentifier("login", sender: self)
                }else{
                    print("登陆失败")
                }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        guideView()
                

    }
    func guideView(){
        var pages = [EAIntroPage]()
        pages.append(setPage("image1", title: "第一个页面"))
        pages.append(setPage("image2", title: "第二个页面"))
        pages.append(setPage("image3", title: "第三个页面"))
        let intro = EAIntroView(frame: self.view.frame, andPages: pages)
        intro.delegate = self
        intro.showInView(self.view)
        
    }
    func setPage(img: String,title: String)->EAIntroPage{
        let page = EAIntroPage()
        page.bgImage = UIImage(named: img)
        page.title = title
        return page
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        self.view.endEditing(true)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
