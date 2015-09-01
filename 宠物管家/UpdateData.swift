
//
//  updateData.swift
//  宠物管家
//
//  Created by lyj on 15/8/18.
//  Copyright © 2015年 lyj. All rights reserved.
//

import Foundation
//数据源
class UpdateData {
    //cell的标题数据源
    static let titiles = ["1、观察狗狗的精神状态和行走步态","2、观察眼睛及眼部","3、观察鼻子","4、掰开狗狗的嘴，检查牙齿和口腔","5、观察耳道","6、坚持梳毛，仔细观察皮肤情况","7、请注意观察狗狗大便的颜色和状态"]
    //采用二维数组定义每个按钮的标题
    static let btnTitles = [["摆动尾巴","愁容满面，没有朝气，行走异常","精神不振，身体软弱无力，动作迟钝，尾部下垂"],["眼睛清澈及炯炯有神","过多的眼泪和眼屎","狗狗不停用前足挠眼睛"],["鼻头除了睡觉和刚睡醒时，其它时间都是冷湿状态","鼻子热干","鼻头有流鼻涕"],["口内的黏膜呈粉红色","牙齿黄、口臭","牙齿呈深红色或暗红色"],["耳朵干净、无臭味","耳道内堆积耳垢","耳垢堆积、耳臭"],["毛发浓密健康","皮屑掉落，皮屑多","皮肤上有红点，脱毛现象"],["便便圆柱状、黄色","便便较软、黄色","便便稀稠、其他颜色"]]
    static let description = ["爱宠物胜过爱自己，是一个善良合格的主人!","也许你爱宠物，但是却没有关爱它，一个爱宠物的主人。","宠物只是你生活中的玩具，坏了就扔了，可有可无，在国外，也许你要坐牢。"]
    //用户选择后的分数


    static var spiderAllScore = [1,1,1,1,1]
    
    
    //返回综合分数
    static func queryAllScoreData()->Int{
        spiderAllScore[0] = queryhealthData().first!//健康度
        spiderAllScore[1] = querycleanData()//清洁度
        spiderAllScore[2] = 80//不饥饿
        spiderAllScore[3] = skillData()//技能
        var sum = 0
        for var i = 0 ; i < 4; i++ {
            sum += spiderAllScore[i]
        }
        spiderAllScore[4] = Int(sum/4)
        return Int(sum/4)
    }
    //返回蜘蛛网图分数数组
    static func queryspiderData()->[Float]{
        var a = [Float]()
        for d in spiderAllScore{
            a.append(Float(d/20))
        }
        return a
    }
    //返回健康分数数组
    static func queryhealthData()->[Int]{
        var a = [Int]()
        let scArr = Score.selectWhere(nil, groupBy: nil, orderBy: "hostID desc", limit: "5") as! [Score]
        for f in scArr{
            a.append(Int(f.feshu)! * 3)
        }
        return a
    }
    //返回清洁度分数
    static func querycleanData()->Int{
        var clean = [1,1,1,1]
        let cleans = Score.selectWhere(nil, groupBy: nil, orderBy: "hostID desc", limit: "1") as! [Score]
        clean[0] = Int(cleans[0].num2)!
        clean[1] = Int(cleans[0].num4)!
        clean[2] = Int(cleans[0].num5)!
        clean[3] = Int(cleans[0].num6)!
        var sum = 0
        for i in clean{
            sum += i
        }
        sum *= 5
        return sum
    }
    //返回技能分数
    static func skillData()->Int{
        return PetSkills.petskills.count > 5 ? 100:PetSkills.petskills.count/5 * 100
    }

//    static func hungerData(date :NSData)->Float{
//        func timeDiffer(){
//            let a = Int(date.timeIntervalSinceNow)
//            let h = Int(a / 3600)
//            let m = Int((a - h * 3600)/60)
//            let s = Int(a - h * 3600 - m * 60)
//            print("h:\(h)   m:\(m)   s:\(s)")
//            if h > 0{
//                print("主人,我好饿啊,已经超过\(h)小时没吃东西了,给我点吃的把")
//                return
//            }
//            if m > 0{
//                print("主人,我好饿啊,已经超过\(m)分钟没吃东西了,给我点吃的把")
//                return
//            }
//            if s > 0{
//                print("主人,我好饿啊,已经超过\(s)秒没吃东西了,给我点吃的把")
//                return
//            }
//            
//        }
//    
//    }
    
    
    
    
    
    
    
    
}
/**
1、观察狗狗的精神状态和行走步态。
精神不振，身体软弱无力，动作迟钝，尾部下垂（1分）
愁容满面，没有朝气，行走异常（3分）
摆动尾巴（5分）

2、观察眼睛及眼部
眼睛清澈及炯炯有神（5分）
过多的眼泪和眼屎（3分）
狗狗不停用前足挠眼睛（1分）

3、观察鼻子。
鼻头除了在睡觉和刚睡醒时，其它时间都是冷湿状态（5分）
鼻子热干（3分）
鼻头有流鼻涕（1分）

4、掰开狗狗的嘴，检查牙齿和口腔。
口内的黏膜呈粉红色（5分）
牙齿黄、口臭（3分）
牙齿呈深红色或暗红色（1分）

5、观察耳道。
耳朵干净、无臭味（5分）
耳道内堆积耳垢（3分）
耳垢堆积、耳臭（1分）

6、坚持梳毛，仔细观察皮肤情况
毛发浓密健康（5分）
皮屑掉落，皮屑多（3分）
皮肤上有红点，脱毛现象（1分）

7、请注意观察狗狗大便的颜色和状态。
便便圆柱状、黄色（5分）
便便较软、黄色（3分）
便便稀稠、其他颜色（1分）


29-35分，爱宠物胜过爱自己，是一个善良合格的主人。
15-29分，也许你爱宠物，但是却没有关爱它，一个爱宠物的主人。
7-15分，宠物只是你生活中的玩具，坏了就扔了，可有可无，在国外，也许你要坐牢。

*/