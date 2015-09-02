//
//  LoginViewController.swift
//  宠物管家
//
//  Created by lyj on 15/8/8.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit
import Pitaya
enum LoginShowType{//登陆界面光标所在位置的三种状态
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

    func loginBtnClick() {//点击登陆按钮进行登陆
        print("dianji")
        let Id = textUser.text!
        let Pwd = txtPwd.text!
        //异步请求数据
        Pitaya.request(.POST, url: "http://www.lyj210.cn/cwgj/index.php/Home/Index/selectUser", params: ["uemail":Id, "upwd":Pwd], errorCallback: { (error) -> Void in
            print("请检查网络是否已连接")
            }) { (data, response, error) -> Void in
                if data == nil{
                    print("网络是否已连接")
                    ProgressHUD.showError("请检查网络是否已连接")
                    self.view.endEditing(true)
                    return
                }
                let json = JSON(data: data!)
                if json["state"] == 1{
                    ProgressHUD.showSuccess("登陆成功")
                    //登陆成功记录登陆时的账号,昵称等信息
                    UserInfo.uemail = Id
                    let uname = json["uname"]
                    let usign = json["usign"]
                    UserInfo.uname = "\(uname)"
                    UserInfo.usign = "\(usign)"
                    print(UserInfo.uname)
                    self.recordUemail(Id)
                    //登陆成功进行界面跳转
                    self.performSegueWithIdentifier("login", sender: self)
                }else{
                    SweetAlert().showAlert("登陆失败", subTitle: "请检查账号密码是否正确!", style: AlertStyle.Error)
                }
        }
        
    }
    
    //记录登陆的账号
    func recordUemail(uemail: String){
        let loginfo = LoginInfo()
        loginfo.hostID = 1
        loginfo.uemail = uemail
        
        if LoginInfo.save(loginfo){
            print("保存成功")
        }
        let s = LoginInfo.selectWhere(nil, groupBy: nil, orderBy: nil, limit: nil) as! [LoginInfo]
        print(s[0].uemail)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true

        viewLoginInit()//初始化登陆界面
        
        showType = LoginShowType.NONE
        
        let gg = ISGuide.selectWhere(nil, groupBy: nil, orderBy: nil, limit: nil) as! [ISGuide]
        if gg.count == 0{
            let gu = ISGuide()
            gu.hostID = 1
            gu.isguide = true
            ISGuide.save(gu)
            guideView()
        }
        //初始化引导界面
        
        
    }
    //引导界面
    func guideView(){
        var pages = [EAIntroPage]()
        pages.append(setPage("b1", title: "Pets are human's best friends",titlePostionOffSet: self.view.frame.height/2 - 80,color: UIColor(hex: "E45825")!))
        pages.append(setPage("b2", title: "Please give your pet a good master",titlePostionOffSet: -50,color: UIColor.redColor()))
        pages.append(setPage("b3", title: "PetHk to help you\nLet's Go",titlePostionOffSet: 100,color: UIColor(hex: "A3D714")!))
        
        
        let intro = EAIntroView(frame: self.view.frame, andPages: pages)
        intro.delegate = self
        intro.showInView(self.view) 
    }
    func setPage(img: String,title: String,titlePostionOffSet: CGFloat,color: UIColor)->EAIntroPage{
        let page = EAIntroPage()
        page.bgImage = UIImage(named: img)
        page.title = title
        page.titleColor = color
        page.titleFont = UIFont(name: "Zapfino", size: 28)
        page.titlePositionY = self.view.frame.height/2 + titlePostionOffSet
        return page
    }
    //登陆见面用代码进行初始化
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
        
        loginBtn.setTitle("登       陆", forState: UIControlState.Normal)
        loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginBtn.backgroundColor = UIColor(red: 102/256, green: 150/256, blue: 209/256, alpha: 0.95)
        loginBtn.addTarget(self, action: "loginBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        vLogin.addSubview(loginBtn)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        self.view.endEditing(true)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if showType != LoginShowType.PWD{
            return
        }
        showType = LoginShowType.NONE
        showTypeNoneAnimate()
    }
    //根据光标所在位置判断执行相应的动画效果
    func showTypeNoneAnimate(){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.imgLeftHand.frame = CGRectMake(self.imgLeftHand.frame.origin.x - 60, self.imgLeftHand.frame.origin.y + 30, self.imgLeftHand.frame.size.width, self.imgLeftHand.frame.size.height)
            
            self.imgRightHand.frame = CGRectMake(self.imgRightHand.frame.origin.x + 48, self.imgRightHand.frame.origin.y + 30, self.imgRightHand.frame.size.width, self.imgRightHand.frame.size.height)
            self.imgLeftHandGone.frame = CGRectMake(self.imgLeftHandGone.frame.origin.x - 70, self.imgLeftHandGone.frame.origin.y, 40, 40);
            
            self.imgRightHandGone.frame = CGRectMake(self.imgRightHandGone.frame.origin.x + 30, self.imgRightHandGone.frame.origin.y, 40, 40)
        })
    }
    //点击输入框执行动画
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.isEqual(textUser){
            if showType != LoginShowType.PWD{
                return
            }
            showType = LoginShowType.USER
            showTypeNoneAnimate()
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
