//
//  myTableView.swift
//  宠物管家
//
//  Created by lyj on 15/8/12.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit

class myTableView: UITableView {
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        endEditing(true)
    }

}
