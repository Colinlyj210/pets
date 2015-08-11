//
//  User.swift
//  宠物管家
//
//  Created by lyj on 15/8/10.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit
class User: BaseModel {
    var userName : String!
    var userEmail : String!
    var userPwd : String!
    var userSign : String?
    var pet : Pet!
}
