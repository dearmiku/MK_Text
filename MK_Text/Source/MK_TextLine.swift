//
//  MK_TextLine.swift
//  MK_Text
//
//  Created by MBP on 2018/1/26.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreText


protocol MK_TextLineProtocol{

    ///将内容绘制到上下文中~
    func drawInContext(context:CGContext,size:CGSize)

}


///绘制字行~
struct MK_TextLine_String{

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
