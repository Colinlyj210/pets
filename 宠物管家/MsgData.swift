
//
//  MsgData.swift
//  宠物管家
//
//  Created by lyj on 15/8/17.
//  Copyright © 2015年 lyj. All rights reserved.
//

import Foundation
import Pitaya
class MsgData {
    private(set) var datas = [MsgInfo]()
    init(){
        datas = loadData()
    }
    private func loadData()->[MsgInfo]{
        var msgInfo = [MsgInfo]()
        //        Pitaya.request(.GET, url: "http:www.lyj210.cn", errorCallback: { (error) -> Void in
        //            print("获取失败")
        //            }) { (data, response, error) -> Void in
        //                let json = JSON(data: data!)
        //                msgInfo.append(MsgInfo(userImg: "", userName: "", time: "", contentText: ""))
        //        }
        
        
        
        return msgInfo
    }
    
}