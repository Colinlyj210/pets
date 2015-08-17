//
//  LoginViewController.swift
//  宠物管家
//
//  Created by lyj on 15/8/8.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit
import Pitaya
enum LoginShowType{
    case NONE
    case USER
    case PWD
}
class LoginViewController: UIViewController,EAIntroDelegate ,UITextFieldDelegate{
    var textUser: UITextField!
    var txtPwd: UITextField!
    var imgLeftHand:UIImageView!
    var imgRightHand:UIImageView!
    var imgLeftHandGone:UIImageView!
    var imgRightHandGone:UIImageView!
    var loginBtn: UIButton!
    var showType:LoginShowType!

    func loginBtnClick() {
        print("dianji")
        let Id = textUser.text!
        let Pwd = txtPwd.text!
        
        Pitaya.request(.POST, url: "http://www.lyj210.cn/cwgj/index.php/Home/Index/selectUser", params: ["uemail":Id, "upwd":Pwd], errorCallback: { (error) -> Void in
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

        viewLoginInit()
        
        showType = LoginShowType.NONE
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

    func viewLoginInit(){
        let imgLogin = UIImageView(frame: CGRectMake(self.view.frame.width / 2 - 211 / 2, 60, 211, 109))
        imgLogin.image = UIImage(named: "owl-login")
        imgLogin.layer.masksToBounds = true
        self.view.addSubview(imgLogin)
        
        imgLeftHand = UIImageView(frame: CGRectMake(1, 90, 40, 65))
        imgLeftHand.image = UIImage(named: "owl-login-arm-left")
        imgLogin.addSubview(imgLeftHand)
        
        imgRightHand = UIImageView(frame: CGRectMake(imgLogin.frame.size.width / 2 + 60, 90, 40, 65))
        imgRightHand.image = UIImage(named: "owl-login-arm-right")
        imgLogin.addSubview(imgRightHand)
        let vLogin = UIView(frame: CGRectMake(25, 160, self.view.frame.width - 50, 185))
        vLogin.layer.borderWidth = 0.5
        vLogin.layer.borderColor = UIColor.lightGrayColor().CGColor
        vLogin.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(vLogin)

        imgLeftHandGone = UIImageView(frame: CGRectMake(self.view.frame.width / 2 - 100, /*vLogin.frame.origin.y*/160 - 22, 40, 40))
        imgLeftHandGone.image = UIImage(named: "icon_hand")
        self.view.addSubview(imgLeftHandGone)
        imgRightHandGone = UIImageView(frame: CGRectMake(self.view.frame.width / 2 + 62, /*vLogin.frame.origin.y*/160 - 22, 40, 40))
        imgRightHandGone.image = UIImage(named: "icon_hand")
        self.view.addSubview(imgRightHandGone)

        textUser = UITextField(frame: CGRectMake(25, 20, vLogin.frame.size.width - 50, 38))
        textUser.placeholder = "请输入邮箱账号"
        textUser.delegate = self
        textUser.layer.cornerRadius = 5;
        textUser.layer.borderWidth = 0.5
        textUser.layer.borderColor = UIColor.lightGrayColor().CGColor
        textUser.leftView = UIView(frame: CGRectMake(0, 0, 44, 44))
        textUser.leftViewMode = UITextFieldViewMode.Always
        let imguser = UIImageView(frame: CGRectMake(11, 11, 22, 22))
        imguser.image = UIImage(named: "iconfont-user")
        textUser.leftView?.addSubview(imguser)
        vLogin.addSubview(textUser)
        
        txtPwd = UITextField(frame: CGRectMake(25, 70, vLogin.frame.size.width - 50, 38))
        txtPwd.placeholder = "请输入密码"
        txtPwd.delegate = self
        txtPwd.layer.cornerRadius = 5;
        txtPwd.layer.borderWidth = 0.5
        txtPwd.secureTextEntry = true
        txtPwd.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtPwd.leftView = UIView(frame: CGRectMake(0, 0, 44, 44))
        txtPwd.leftViewMode = UITextFieldViewMode.Always
        let imgpwd = UIImageView(frame: CGRectMake(11, 11, 22, 22))
        imgpwd.image = UIImage(named: "iconfont-password")
        txtPwd.leftView?.addSubview(imgpwd)
        vLogin.addSubview(txtPwd)
        
        loginBtn = UIButton(frame: CGRectMake(25, 125, vLogin.frame.size.width - 50, 38))
        loginBtn.layer.cornerRadius = 5
        
        loginBtn.setTitle("登          陆", forState: UIControlState.Normal)
        loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginBtn.backgroundColor = UIColor.blueColor()
        loginBtn.addTarget(self, action: "loginBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        vLogin.addSubview(loginBtn)

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
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.isEqual(textUser){
            if showType != LoginShowType.PWD{
                return
            }
            showType = LoginShowType.USER
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.imgLeftHand.frame = CGRectMake(self.imgLeftHand.frame.origin.x - 60, self.imgLeftHand.frame.origin.y + 30, self.imgLeftHand.frame.size.width, self.imgLeftHand.frame.size.height)
                
                self.imgRightHand.frame = CGRectMake(self.imgRightHand.frame.origin.x + 48, self.imgRightHand.frame.origin.y + 30, self.imgRightHand.frame.size.width, self.imgRightHand.frame.size.height)
                self.imgLeftHandGone.frame = CGRectMake(self.imgLeftHandGone.frame.origin.x - 70, self.imgLeftHandGone.frame.origin.y, 40, 40);
                
                self.imgRightHandGone.frame = CGRectMake(self.imgRightHandGone.frame.origin.x + 30, self.imgRightHandGone.frame.origin.y, 40, 40)
            })
        }else if textField.isEqual(txtPwd){
            if showType == LoginShowType.PWD{
                return
            }
            showType = LoginShowType.PWD
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.imgLeftHand.frame = CGRectMake(self.imgLeftHand.frame.origin.x + 60, self.imgLeftHand.frame.origin.y - 30, self.imgLeftHand.frame.size.width, self.imgLeftHand.frame.size.height)
                self.imgRightHand.frame = CGRectMake(self.imgRightHand.frame.origin.x - 48, self.imgRightHand.frame.origin.y - 30, self.imgRightHand.frame.size.width, self.imgRightHand.frame.size.height)
                self.imgLeftHandGone.frame = CGRectMake(self.imgLeftHandGone.frame.origin.x + 70, self.imgLeftHandGone.frame.origin.y, 0, 0)
                self.imgRightHandGone.frame = CGRectMake(self.imgRightHandGone.frame.origin.x - 30, self.imgRightHandGone.frame.origin.y, 0, 0)
            })
        }
        
    }


}
