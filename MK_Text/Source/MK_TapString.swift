//
//  MK_TapString.swift
//  MK_Text
//
//  Created by MBP on 2018/1/30.
//  Copyright © 2018年 MBP. All rights reserved.
//

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

public typealias MK_TapString_Block = (_ str:NSAttributedString)->()

///可点击富文本
class MK_TapStringAttr : NSObject {

    static let AttributeKey = "MK_TapStringAttr_Key"

    var clickBlock:MK_TapString_Block!

    var str:NSAttributedString!

    init(tapBlock:@escaping MK_TapString_Block) {
        super.init()
        clickBlock = tapBlock
    }
    
}

public extension NSAttributedString {
    ///请注意循环引用~
    public func mk_tap(clickBlock:@escaping MK_TapString_Block)->NSMutableAttributedString{
        let res = NSMutableAttributedString.init(attributedString: self)
        let tap = MK_TapStringAttr.init(tapBlock: clickBlock)
        tap.str = self
        res.addAttribute(NSAttributedStringKey.init(MK_TapStringAttr.AttributeKey), value: tap, range: self.range)
        return res
    }

}

extension NSAttributedString {
    func getTapStringAttr()->MK_TapStringAttr? {
        let res:MK_TapStringAttr? = self.getAttributeValue(name: MK_TapStringAttr.AttributeKey)
        return res
    }
}


