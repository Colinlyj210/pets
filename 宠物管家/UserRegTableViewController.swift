//
//  UserRegTableViewController.swift
//  宠物管家
//
//  Created by lyj on 15/8/8.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit
import Pitaya
class UserRegTableViewController: UITableViewController {

    @IBOutlet var requireTextFields: [UITextField]!
    @IBOutlet weak var textUserName: UITextBox!
    @IBOutlet weak var textUserEmail: UITextBox!
    @IBOutlet weak var textUserPwd: UITextBox!
    @IBOutlet weak var textConfirmPwd: UITextBox!
    @IBOutlet weak var textPetName: UITextBox!
    @IBOutlet weak var textPetKinds: UITextBox!
    @IBOutlet weak var textUserSign: UITextBox!
    @IBOutlet weak var textPetBirthday: UITextBox!
    @IBOutlet weak var textPetSkill: UITextBox!
    var possibleInputs : Inputs = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "userRegistered")
        self.navigationItem.rightBarButtonItem?.enabled = true

        check(.String, textf: textUserName, max: 10, maxStr: "昵称最多10位", min: 2, minStr: "昵称至少2位", inputsType: Inputs.userName,isemail: false)
        check(.String, textf: textUserEmail, max: 10, maxStr: "2", min: 2, minStr: "2", inputsType: Inputs.userEmail, isemail: true)
        check(.String, textf: textUserPwd, max: 16, maxStr: "密码最多16位", min: 6, minStr: "密码至少6位", inputsType: Inputs.userPwd, isemail: false)
        check(.String, textf: textConfirmPwd, max: 16, maxStr: "密码最多16位", min: 6, minStr: "密码至少6位", inputsType: Inputs.userConfirmPwd, isemail: false)
        check(.String, textf: textPetName, max: 10, maxStr: "宠物名字最多10位", min: 2, minStr: "宠物名字至少2位", inputsType: Inputs.petName, isemail: false)
        check(.String, textf: textPetKinds, max: 10, maxStr: "最多10位", min: 2, minStr: "至少2位", inputsType: Inputs.petKinds, isemail: false)

    
    }

    func check(vtype: AJWValidatorType, textf: UITextBox, max: UInt,maxStr: String,min: UInt, minStr: String ,inputsType: Inputs,isemail: Bool){
        let v = AJWValidator(type: vtype)
        if isemail{
            v.addValidationToEnsureValidEmailWithInvalidMessage("Email格式不对")
        }else{
            v.addValidationToEnsureMinimumLength(min, invalidMessage: minStr)
            v.addValidationToEnsureMaximumLength(max, invalidMessage: maxStr)
        }
        textf.ajw_attachValidator(v)
        v.validatorStateChangedHandler = { (newState: AJWValidatorState) -> Void in
            switch newState {
                
            case .ValidationStateValid:
                textf.highlightState = .Default
                self.possibleInputs.unionInPlace(inputsType)
                
            default:
                let errorMsg = v.errorMessages.first as? String
                textf.highlightState = UITextBoxHighlightState.Wrong(errorMsg!)
                
                self.possibleInputs.subtractInPlace(inputsType)
            }
            
            self.navigationItem.rightBarButtonItem?.enabled = self.possibleInputs.isAllOK()
            
        }
    
    }
    
    
    //注册新用户
    func userRegistered(){
        if textUserPwd.text != textConfirmPwd.text{
            ProgressHUD.showError("两次密码输入不一样\n请重新输入!", interaction: false)
            return
        }else{
            let param = ["uname":textUserName.text!, "upwd":textUserPwd.text!,"uemail":textUserEmail.text!, "usign":textUserSign.text! ,"pname": textPetName.text!,"pkinds":textPetKinds.text!,"pbirthday":textPetBirthday.text!,"pskill":textPetSkill.text!]
            Pitaya.request(.POST, url: "http://www.lyj210.cn/cwgj/index.php/Home/Index/addUser", params: param, errorCallback: { (error) -> Void in
                print("出错了")
                }) { (data, response, error) -> Void in
                    let json = JSON(data: data!)
                    if json["state"] == 1{
                        ProgressHUD.showSuccess("注册成功", interaction: false)
                        self.writeSqlite()
                        self.navigationController?.popViewControllerAnimated(true)//返回到前一个界面

                    }else if json["state"] == 2{
                        ProgressHUD.showError("该邮箱已注册", interaction: false)
                    }else{
                        ProgressHUD.showError("注册失败", interaction: false)
                    }
            }
        }
    }
    func writeSqlite(){
        let pet = Pet()
        pet.hostID = 1
        pet.petName = textPetName.text
        pet.petKinds = textPetKinds.text
        pet.petBirthday = textPetBirthday.text
        pet.petSkill = textPetSkill.text
        let user = User()
        user.hostID = 1
        user.userName = textUserName.text
        user.userPwd = textUserPwd.text
        user.userEmail = textUserEmail.text
        user.userSign = textUserSign.text
        user.pet = pet
        User.save(user)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

        /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
