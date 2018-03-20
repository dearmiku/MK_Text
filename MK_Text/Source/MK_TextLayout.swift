//
//  MK_TextLayout.swift
//  MK_Text
//
//  Created by MBP on 2018/1/26.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreText
#if os(macOS)
    import AppKit
#else
    import UIKit
#endif




public extension NSAttributedString{

    public var mk_size:CGSize{
        var res:CGSize
        #if os(macOS)
            res = self.boundingRect(with: CGSize(width: INTPTR_MAX, height: INTPTR_MAX), options: NSString.DrawingOptions.usesLineFragmentOrigin).size
        #else
            res = self.boundingRect(with: CGSize(width: INTPTR_MAX, height: INTPTR_MAX), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
        #endif
        return res
    }
}

public extension MK_Label {

    ///字行数
    public var numberOfLines:Int {
        get{
            return self.layout.numberOfLine
        }
        set{
            self.layout.numberOfLine = newValue
        }
    }
    ///是否为自动约束
    override var translatesAutoresizingMaskIntoConstraints:Bool {
        didSet{
            self.layout.isAutoLayoutSize = !translatesAutoresizingMaskIntoConstraints
        }
    }

    ///布局对齐方式
    enum Alignment{
        ///左对齐
        case left
        ///居中对齐
        case center
        ///右对齐
        case right
    }

    ///文字对其方式(默认左对齐)
    public var alignment:Alignment{
        get{
            return self.layout.alignment
        }
        set{
            self.layout.alignment = newValue
        }
    }

    ///判断是否进行提前换行条件闭包(默认不做提前换行) 富文本 为当前Label要绘制的
    public var makeNewLineEarlyConditionBlock:((NSAttributedString,Int)->(Bool)){
        get{
            return self.layout.makeNewLineEarlyConditionBlock
        }
        set{
            self.layout.makeNewLineEarlyConditionBlock = newValue
        }
    }

    ///单词分隔符(单个字符)数组
    public var wordSeparatorArr:[String] {
        get{
            return self.layout.wordSeparatorArr
        }
        set{
            self.layout.wordSeparatorArr = newValue
        }
    }

}

protocol MK_TextLayout_Delegate {

    ///得到富文本绘制大小
    func getLayoutDrawSize(newSize:CGSize)
    ///获取绘制字行的父视图
    func getLinesSuperView()->MK_View
}

///富文本管理对象~
class MK_TextLayout:NSObject{

    var lineArray:[MK_TextLine]?

    var delegate:MK_TextLayout_Delegate!

    var numberOfLine:Int = 0

    var alignment:MK_Label.Alignment = .left

    ///是否自动扩充大小(自动布局)
    var isAutoLayoutSize : Bool  = false

    ///判断是否进行提前换行条件闭包
    var makeNewLineEarlyConditionBlock:((NSAttributedString,Int)->(Bool)) = {(str:NSAttributedString,index:Int)->Bool in
        return false
    }

    ///单词分隔符(单个字符)数组
    var wordSeparatorArr:[String] = [" "]
}


///生成布局
extension MK_TextLayout {
    func layout(str:NSMutableAttributedString,drawSize:CGSize)->([MK_TextLine],CGSize){
        
        var currentBottomLineY = CGFloat(0)
        var lineArr:[MK_TextLine] = []
        let size = getLayoutSize(size: drawSize)

        var width = CGFloat(0.0)
        var hight = CGFloat(0.0)

        ///判断是否继续绘制Line 
        getMK_LineAndJudgeIsCancel(str: str, maxWidth: size.width,maxHight:size.height) { (line, lineHeight,lineWidth) -> (Bool) in
            currentBottomLineY += lineHeight

            if lineWidth > width { width = lineWidth }
            hight += lineHeight

            ///增加新行
            if ceil(currentBottomLineY) <= ceil(size.height){

                ///根据对齐方式调整布局
                switch self.alignment{

                case .left:
                    break
                case .center:
                    line.xOff = (size.width - lineWidth)*0.5
                case .right:
                    line.xOff = size.width - lineWidth
                }
                lineArr.append(line)
            }

            return currentBottomLineY >= size.height || (self.numberOfLine > 0 && self.numberOfLine <= lineArr.count)
        }

        let newSize = CGSize.init(width: width, height: hight)

        ///启动自填充时修改Line绘制位置~
        if isAutoLayoutSize {
            for line in lineArr {
                line.lineStartCenterPoint.y += (hight - size.height)
            }
            delegate.getLayoutDrawSize(newSize: newSize)
        }

        self.lineArray = lineArr
        if isAutoLayoutSize{
            return (lineArr,newSize)
        }else{
            return (lineArr,size)
        }
    }
    
    ///获得line 并判断是否继续
    func getMK_LineAndJudgeIsCancel(str:NSMutableAttributedString,maxWidth:CGFloat,maxHight:CGFloat,isCancel:@escaping (MK_TextLine,CGFloat,CGFloat)->(Bool)){

        guard str.length != 0 else { return }
        
        var currentXR = CGFloat(0)
        var currentYR = CGFloat(0)
        
        var currentCenterToTop = CGFloat(0)
        var currentCenterToBottom = CGFloat(0)
        var currentRange = NSRange.init(location: 0, length: 1)
        
        var ctt = CGFloat(0)    ///中心距离顶部距离
        var ctb = CGFloat(0)    ///中心距离底部距离
        var cW = CGFloat(0)


        var sentence:MK_Text_Sentence_Protocol? = nil
        var sentenceArr:[MK_Text_Sentence_Protocol] = []

        ///当前处理的富文本下标
        var i = 0

        ///向外输出Line 并判断是否继续解析~
        func getCanelResultAndOutLine(lineWidth:CGFloat)->Bool{

            let y = maxHight - currentYR - (currentCenterToTop + currentCenterToBottom)*0.5 
            
            let line = MK_TextLine.init(sentArr: sentenceArr, startCenterPoint: CGPoint.init(x: 0, y: y), lineHeight: (currentCenterToTop + currentCenterToBottom), centerOff: (currentCenterToTop - currentCenterToBottom)*0.5)

            return isCancel(line,currentCenterToBottom + currentCenterToTop, lineWidth)
        }
        
        ///判断当前宽度是否越界,是否继续向下处理 
        func whenWidthIsOutofBorder()->Bool{
            
            if Int(cW + currentXR) > Int(maxWidth) {
                ///越界将剩余字句加入
                if let beforeSec = sentence {
                    sentenceArr.append(beforeSec)
                }

                ///获取下一行的初始字句 和 初始 X
                let (nextLineStartSentence,nextLineCurrentXR,nextLineCTT,nextLineCTB) = dealMakeNewLineEarlyCondition()

                ///计算当前字行(字句数组)的 CTT,CTB参数
                calculateSentenceArrPa()

                let isCancelRes = getCanelResultAndOutLine(lineWidth: currentXR)
                ///换行处理
                if !isCancelRes {

                    
                    
                    currentYR += (currentCenterToTop + currentCenterToBottom)
                    currentXR = nextLineCurrentXR
                    sentenceArr.removeAll()
                    sentence = nextLineStartSentence
                    currentCenterToTop = nextLineCTT
                    currentCenterToBottom = nextLineCTB
                }
                return isCancelRes
            }
            return false
        }


        ///处理提前换行事宜,返回下一行的初始字句 和 宽度 CTT 和 CTB 距离
        func dealMakeNewLineEarlyCondition()->(MK_Text_Sentence_Protocol?,CGFloat,CGFloat,CGFloat){
            var nextLineStartSentence:MK_Text_Sentence_Protocol? = nil
            var nextLineCurrentXR = CGFloat(0)
            var nextLineInitialCTT = CGFloat(0)
            var nextLineInitialCTB = CGFloat(0)

            /// 对字句数组最后一元素进行判断 判断当前元素是否将单个词语拆解
            if i + 1 < str.length && sentenceArr.count > 1{

                let cha = str.attributedSubstring(from: NSRange.init(location: i, length: 1))
                ///判断是否为单词分隔符
                let condi = wordSeparatorArr.reduce(false, { (out, item) -> Bool in
                    if item == cha.string{
                        return true
                    }
                    return out
                })
                if makeNewLineEarlyConditionBlock(str,i) && !condi {

                    nextLineStartSentence = sentenceArr.last
                    sentenceArr.removeLast()
                    nextLineCurrentXR = nextLineStartSentence!.size.width
                    nextLineInitialCTT = nextLineStartSentence!.ctt
                    nextLineInitialCTB = nextLineStartSentence!.ctb
                    currentXR -= nextLineStartSentence!.size.width
                }
            }
            return (nextLineStartSentence,nextLineCurrentXR,nextLineInitialCTT,nextLineInitialCTB)
        }

        ///计算当前 字句数组的 CTT,CTB,CurrentX 数据
        func calculateSentenceArrPa(){
            sentenceArr.forEach { (item) in
                currentCenterToTop = max(currentCenterToTop, item.ctt)
                currentCenterToBottom = max(currentCenterToBottom, item.ctb)
            }
        }
        
        
        //MARK:- 遍历富文本
        while(i < str.length){
            
            currentRange.location = i
            let cha = str.attributedSubstring(from: currentRange)
            
            //是否为附件类型
            if let acc = cha.getAccessoryFromCha() {

                cW = acc.acc_Size.MK_Accessory_Width
                ///越界判断
                guard !whenWidthIsOutofBorder() else { return }
                
                ///处理当前布局
                currentXR += cW
                
                //之前是否存在当前字句
                if let beforeSec = sentence{
                    sentenceArr.append(beforeSec)
                    sentence = nil
                }
                let view = self.delegate.getLinesSuperView()
                sentence = MK_Text_SenTence_Accessory.init(accessory: acc, accSize: CGSize.init(width: acc.acc_Size.MK_Accessory_Width, height: acc.acc_Size.MK_Accessory_Height), superView: view)
                
                ///普通富文本串
            }else{
                let size = cha.mk_size
                cW = size.width
                
                ///越界判断
                guard !whenWidthIsOutofBorder() else { return }
                
                ///处理当前布局
                currentXR += cW
                ///当前字句是否为字符串字句
                if let beforeSec = sentence as? MK_Text_SenTence_String {

                    ///判断是否为单词分隔符
                    let condi = wordSeparatorArr.reduce(false, { (out, item) -> Bool in
                        if item == cha.string{
                            return true
                        }
                        return out
                    })
                    ///当为单词分割符时,则将其作为单独一个字句存在
                    if condi{
                        sentenceArr.append(beforeSec)
                        let speSentence =  MK_Text_SenTence_String.init(string: NSMutableAttributedString.init(attributedString: cha), strSize: size)
                        sentenceArr.append(speSentence)
                        sentence = nil
                    }else{
                        beforeSec.str.append(cha)
                        beforeSec.size.width += size.width
                        beforeSec.size.height = max(beforeSec.size.height, size.height)
                    }
                }else{
                    if sentence != nil {
                        sentenceArr.append(sentence!)
                        sentence = nil
                    }
                    sentence = MK_Text_SenTence_String.init(string: NSMutableAttributedString.init(attributedString: cha), strSize: size)
                }
            }
            i += 1
        }


        ///将最后剩余字句加入数组 并输出
        if let beforeSec = sentence {
            sentenceArr.append(beforeSec)
        }
        calculateSentenceArrPa()
        _ = getCanelResultAndOutLine(lineWidth: currentXR)
    }

    ///获取绘制Size大小~
    func getLayoutSize(size:CGSize)->CGSize{

        if isAutoLayoutSize {
            var w = CGFloat(0)
            if size.width == 1 {
                w = 10000.0
            }else{
                w = size.width
            }
            var h = CGFloat(0)
            if size.height == 1 {
                h =  10000.0
            }else{
                h = size.height
            }
            return CGSize.init(width: w, height: h)
        }

        return size
    }
}

