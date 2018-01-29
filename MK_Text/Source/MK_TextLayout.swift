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

///富文本管理对象~
class MK_TextLayout:NSObject{
    
    
    func layout(str:NSMutableAttributedString,drawSize:CGSize)->[MK_TextLine]{
        
        var currentBottomLineY = CGFloat(0)
        var lineArr:[MK_TextLine] = []

        getMK_LineAndJudgeIsCancel(str: str, maxWidth: drawSize.width) { (line, lineHeight) -> (Bool) in
            lineArr.append(line)
            currentBottomLineY += lineHeight
            return currentBottomLineY >= drawSize.height
        }

        return lineArr
    }
    


    ///获得line 并判断是否继续
    func getMK_LineAndJudgeIsCancel(str:NSMutableAttributedString,maxWidth:CGFloat,isCancel:@escaping (MK_TextLine,CGFloat)->(Bool)){

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


        ///当宽度越界
        func whenWidthIsOutofBorder()->Bool{

            if cW + currentXR >= maxWidth {
                if let beforeSec = sentence {
                    sentenceArr.append(beforeSec)
                }


                let line = MK_TextLine.init(sentenceArr: sentenceArr, lineStartCenterPoint: CGPoint.init(x: 0, y: currentYR))

                let isCancelRes = isCancel(line,currentCenterToBottom + currentCenterToTop)
                ///换行处理
                if !isCancelRes {

                    currentYR += (currentCenterToTop + currentCenterToBottom)
                    currentXR = CGFloat(0)
                    sentenceArr.removeAll()
                }
                return isCancelRes
            }
            return false
        }


        //遍历富文本
        for i in 0..<str.length{

            let cha = str.attributedSubstring(from: currentRange)
            currentRange.location = i

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
                    beforeSec.size.height += size.height
                }else{
                    sentence = MK_Text_SenTence_String.init(string: NSMutableAttributedString.init(attributedString: cha), strSize: size)
                }
            }
        }
    }
}
