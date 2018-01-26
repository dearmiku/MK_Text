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

///绘制字行~
struct MK_TextLine{
    
    var str:NSMutableAttributedString
    
    var rect:CGRect = CGRect.zero
    
    ///将line 绘制至指定上下文
    func drawInContext(context:CGContext,size:CGSize){
        let frameSetter = CTFramesetterCreateWithAttributedString(str)
        
        var drawRec:CGRect

        drawRec = CGRect.init(origin: CGPoint.init(x:rect.origin.x, y: size.height - rect.origin.y - rect.size.height), size: rect.size)


        let frame = CTFramesetterCreateFrame(frameSetter, CFRange.init(location: 0, length: str.length), CGPath.init(rect: drawRec, transform: nil), nil)
        CTFrameDraw(frame, context)
    }
}




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
        
        getLineStringArr(str: str, maxWidth: drawSize.width) { (str, size) -> (Bool) in
            let rec = CGRect.init(x: 0.0, y: currentBottomLineY, width: size.width, height: size.height)
            let line = MK_TextLine.init(str: str, rect: rec)
            lineArr.append(line)
            currentBottomLineY += size.height
            
            
            ///这里判断 以下一行的顶部是否出现在当前Rect中
            return currentBottomLineY >= drawSize.height
        }
        return lineArr
    }
    
    ///迭代获取小于等于且接近最大宽度的字符串
    fileprivate func getLineStringArr(str:NSMutableAttributedString,maxWidth:CGFloat,isCancel:(NSMutableAttributedString,CGSize)->(Bool)){
        
        guard str.length != 0 else { return }
        
        var currentWidth = CGFloat(0)
        var currentMaxHi = CGFloat(0)
        var currentStr = NSMutableAttributedString()
        
        for i in 0..<str.length{
            let cha = str.attributedSubstring(from: NSRange.init(location: i, length: 1))
            let size = cha.mk_size
            
            ///超宽
            if currentWidth + size.width >= maxWidth {
                ///取消
                if isCancel(currentStr,CGSize.init(width: currentWidth, height: currentMaxHi)){ return }
                ///重置
                currentWidth = CGFloat(0)
                currentMaxHi = CGFloat(0)
                currentStr = NSMutableAttributedString()
            }else{
                currentStr.append(cha)
                currentWidth += size.width
                if currentMaxHi < size.height {
                    currentMaxHi = size.height
                }
            }
            ///当自然结束 再次进行回调
            if i == str.length - 1 {
                _ = isCancel(currentStr,CGSize.init(width: currentWidth, height: currentMaxHi))
            }
            
        }
    }
}
