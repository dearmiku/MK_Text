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

    var id:Int = Int(NSDate.init().timeIntervalSince1970)

    init(tapBlock:@escaping MK_TapString_Block) {
        super.init()
        clickBlock = tapBlock
    }

    ///获取在指定富文本中的Range
    func getRangeIn(attStr:NSAttributedString)->NSRange?{

        var res:NSRange? = nil
        attStr.enumerateAttributes(in: attStr.range, options: NSAttributedString.EnumerationOptions.init(rawValue: 1)) { (dic, range, isCancel) in
            if let att = dic[NSAttributedStringKey.init(MK_TapStringAttr.AttributeKey)] as? MK_TapStringAttr {
                if att.id == self.id{
                    if res == nil {
                        res = range
                    }else {
                        if range.location < res!.location {
                            res?.location = range.location
                        }
                        if range.length + range.location > res!.length + res!.location {
                            res!.length = range.length + range.location - res!.location
                        }
                    }
                }
            }
        }
        return res
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


