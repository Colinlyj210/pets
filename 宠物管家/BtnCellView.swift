//
//  BtnCellView.swift
//  宠物管家
//
//  Created by lyj on 15/8/23.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit

class BtnCellView: UIView {
    let skillStr = ["游泳","上厕所","玩球","拿东西","看电视"]
    var btns = [UIButton]()
    override func drawRect(rect: CGRect) {

        var frame = CGRectMake(self.frame.width/2 - 75, 0, 150, 30)
        for s in skillStr{
            btns.append(createBtns(frame, str: s))
            self.addSubview(createBtns(frame, str: s))
            frame.origin.y += 40
            
        }
        for i in 0..<skillStr.count{
            btns[i].tag = i
        }
        for var j = 0 ; j < UpdateData.skill.count ; j++ {
            if UpdateData.skill[j] == 0 {
                btns[j].selected = false
            }else if UpdateData.skill[j] == 1 {
                btns[j].selected = true
            }
        }
    }
    
    func createBtns(frame: CGRect, str: String) -> UIButton{
        let btn = UIButton(frame: frame)
        btn.layer.cornerRadius = 5
        btn.backgroundColor = UIColor.clearColor()
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.blueColor().CGColor
        btn.setTitle(str, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
        btn.addTarget(self, action: "btnclick:", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }
    func btnclick(btn: UIButton){
        if btn.selected{
            btn.selected = false
            UpdateData.skill[btn.tag] = 0
            btn.backgroundColor = UIColor.clearColor()
        }else{
            btn.selected = true
            UpdateData.skill[btn.tag] = 1
            btn.backgroundColor = UIColor.blueColor()
        }
    }
    

}
