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



extension NSAttributedString{
    
    var mk_size:CGSize{
        #if os(macOS)
            return self.boundingRect(with: CGSize(width: INTPTR_MAX, height: INTPTR_MAX), options: NSString.DrawingOptions.usesLineFragmentOrigin).size
        #else
            let frameSetter = CTFramesetterCreateWithAttributedString(self)
            return CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRange.init(location: 0, length: 0), nil, CGSize(width: INTPTR_MAX, height: INTPTR_MAX), nil)
        #endif
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

    ///最大宽度
    public var layoutMaxWidth:CGFloat {
        get{
            return self.layout.layoutMaxWidth
        }
        set{
            self.layout.layoutMaxWidth = newValue
        }
    }

    ///最大高度
    public var layoutMaxHight:CGFloat {
        get{
            return self.layout.layoutMaxHight
        }
        set{
            self.layout.layoutMaxHight = newValue
        }
    }

    override var translatesAutoresizingMaskIntoConstraints:Bool {
        didSet{
            self.layout.isAutoLayoutSize = !translatesAutoresizingMaskIntoConstraints
        }
    }

}

protocol MK_TextLayout_Delegate {

    func getLayoutDrawSize(newSize:CGSize)
}

///富文本管理对象~
class MK_TextLayout:NSObject{

    var lineArray:[MK_TextLine]?

    var delegate:MK_TextLayout_Delegate!

    var numberOfLine:Int = 0


    var layoutMaxWidth:CGFloat = -1.0
    var layoutMaxHight:CGFloat = -1.0

    ///是否自动扩充大小(自动布局)
    var isAutoLayoutSize : Bool  = false

}


///生成布局
extension MK_TextLayout {
    func layout(str:NSMutableAttributedString,drawSize:CGSize)->([MK_TextLine],CGSize){
        
        var currentBottomLineY = CGFloat(0)
        var lineArr:[MK_TextLine] = []
        let size = getLayoutSize(size: drawSize)

        var width = CGFloat(0.0)
        var hight = CGFloat(0.0)

        getMK_LineAndJudgeIsCancel(str: str, maxWidth: size.width,maxHight:size.height) { (line, lineHeight,lineWidth) -> (Bool) in
            currentBottomLineY += lineHeight

            if lineWidth > width { width = lineWidth }
            hight += lineHeight

            if currentBottomLineY <= size.height{
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
        
        var ctt = CGFloat(0)
        var ctb = CGFloat(0)
        var cW = CGFloat(0)


        var sentence:MK_Text_Sentence_Protocol? = nil
        var sentenceArr:[MK_Text_Sentence_Protocol] = []
        
        
        ///向外输出Line 并判断是否继续解析~
        func getCanelResultAndOutLine(lineWidth:CGFloat)->Bool{
            if let beforeSec = sentence {
                sentenceArr.append(beforeSec)
            }
            
            let y = maxHight - currentYR - (currentCenterToTop + currentCenterToBottom)*0.5
            
            let line = MK_TextLine.init(sentArr: sentenceArr, startCenterPoint: CGPoint.init(x: 0, y: y), lineHeight: (currentCenterToTop + currentCenterToBottom), centerOff: (currentCenterToTop - currentCenterToBottom)*0.5)
            
            return isCancel(line,currentCenterToBottom + currentCenterToTop, lineWidth)
        }
        
        ///当宽度越界
        func whenWidthIsOutofBorder()->Bool{
            
            if Int(cW + currentXR) > Int(maxWidth) {
                let isCancelRes = getCanelResultAndOutLine(lineWidth: currentXR)
                ///换行处理
                if !isCancelRes {
                    
                    currentYR += (currentCenterToTop + currentCenterToBottom)
                    currentXR = CGFloat(0)
                    sentenceArr.removeAll()
                    sentence = nil
                }
                return isCancelRes
            }
            return false
        }
        
        
        //MARK:- 遍历富文本
        for i in 0..<str.length{
            
            currentRange.location = i
            let cha = str.attributedSubstring(from: currentRange)
            
            //是否为附件类型
            if let acc = cha.getAccessory() {
                ctt = acc.CenterToTop
                ctb = acc.CenterToBottom
                cW = acc.acc_Size.MK_Accessory_Width
                
                ///越界判断
                guard !whenWidthIsOutofBorder() else { return }
                
                ///处理当前布局
                currentXR += cW
                if ctt > currentCenterToTop { currentCenterToTop = ctt }
                if ctb > currentCenterToBottom { currentCenterToBottom = ctb }
                
                //之前是否存在当前字句
                if let beforeSec = sentence{
                    sentenceArr.append(beforeSec)
                    sentence = nil
                }
                sentence = MK_Text_SenTence_Accessory.init(accessory: acc, accSize: CGSize.init(width: acc.acc_Size.MK_Accessory_Width, height: acc.acc_Size.MK_Accessory_Height))
                
                ///普通富文本串
            }else{
                let size = cha.mk_size
                ctt = size.height/2
                ctb = ctt
                cW = size.width
                
                ///越界判断
                guard !whenWidthIsOutofBorder() else { return }
                
                ///处理当前布局
                currentXR += cW
                if ctt > currentCenterToTop { currentCenterToTop = ctt }
                if ctb > currentCenterToBottom { currentCenterToBottom = ctb }
                
                if let beforeSec = sentence as? MK_Text_SenTence_String{
                    beforeSec.str.append(cha)
                    beforeSec.size.width += size.width
                    beforeSec.size.height = currentCenterToBottom + currentCenterToTop
                }else{
                    if sentence != nil {
                        sentenceArr.append(sentence!)
                        sentence = nil
                    }
                    sentence = MK_Text_SenTence_String.init(string: NSMutableAttributedString.init(attributedString: cha), strSize: size)
                }
            }
        }
        _ = getCanelResultAndOutLine(lineWidth: currentXR)
    }

    ///获取绘制Size大小~
    func getLayoutSize(size:CGSize)->CGSize{

        if isAutoLayoutSize {
            var w = CGFloat(0)
            if size.width == 1 {
                w = 10000.0
            }else{
                w = layoutMaxWidth != -1.0 ? layoutMaxWidth : size.width
            }
            var h = CGFloat(0)
            if size.height == 1 {
                h = 10000.0
            }else{
                h = layoutMaxHight != -1.0 ? layoutMaxHight : size.height
            }
            return CGSize.init(width: w, height: h)
        }

        return size
    }
}
