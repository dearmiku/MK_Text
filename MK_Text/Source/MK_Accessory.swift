//
//  MK_Accessory.swift
//  MK_Text
//
//  Created by MBP on 2018/1/25.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreText

public extension NSMutableAttributedString {
    ///内容
    enum ContentType {

        case image (MK_Image,CGSize)

        case view (MK_View,CGSize,MK_View)
    }

    ///对齐方式
    enum AlignType{
        case center

        case bottom

        case top

        case custom(CGFloat)
    }

    ///获取图像富文本
    static func mk_image(im:MK_Image,size:CGSize = CGSize.zero,alignType:AlignType = .center)->NSMutableAttributedString{
        let conSize = size == CGSize.zero ? im.size : size
        let acc = MK_Accessory.init(con: ContentType.image(im, conSize), ali: alignType)
        return acc.turnToAttrStr()
    }
    ///控件富文本
    static func mk_view(view:MK_View,superView:MK_View,size:CGSize,alignType:AlignType = .center)->NSMutableAttributedString{
        let acc = MK_Accessory.init(con: NSMutableAttributedString.ContentType.view(view,size,superView), ali: alignType)
        return acc.turnToAttrStr()
    }
    
}


///富文本中附件
class MK_Accessory:NSObject {

    static var AttributeKeyStr = "MK_Accessory_AttributeKeyStr"

    static let Attribute_PlaceholderStr = " "

    var content:NSMutableAttributedString.ContentType!

    var align:NSMutableAttributedString.AlignType!

    init(con:NSMutableAttributedString.ContentType,ali:NSMutableAttributedString.AlignType) {
        super.init()
        content = con
        align = ali
    }

    class AccessorySize {
        var MK_Accessory_Height:CGFloat = 0.0
        var MK_Accessory_Width:CGFloat = 0.0
        var MK_Accessory_Descent:CGFloat = 0.0
    }

    ///附件大小信息
    var acc_Size = AccessorySize.init()


    ///转换为属性字符串
    func turnToAttrStr()->NSMutableAttributedString{


        switch content! {
        case .image(let (_, size)),.view(let (_, size, _)):
            acc_Size.MK_Accessory_Width = size.width
            acc_Size.MK_Accessory_Height = size.height
        }
        switch align! {
        case .center:
            acc_Size.MK_Accessory_Descent = 0.0
        case .bottom:
            acc_Size.MK_Accessory_Descent = -acc_Size.MK_Accessory_Height * 0.25
        case .top:
            acc_Size.MK_Accessory_Descent = acc_Size.MK_Accessory_Height * 0.25
        case .custom(let (cus)):
            acc_Size.MK_Accessory_Descent = cus * CGFloat(0.5)
        }

        let res = NSMutableAttributedString.init(string: MK_Accessory.Attribute_PlaceholderStr)
        res.addAttributes([NSAttributedStringKey.init(MK_Accessory.AttributeKeyStr):self], range: NSRange.init(location: 0, length: res.length))
        return res
    }
}

extension MK_Accessory {
    
    ///中心对附件顶边的距离
    var CenterToTop:CGFloat{
        get{
            return acc_Size.MK_Accessory_Height * 0.5 - acc_Size.MK_Accessory_Descent
        }
    }
    ///中心对附件底边的距离
    var CenterToBottom:CGFloat{
        get{
            return acc_Size.MK_Accessory_Height * 0.5 + acc_Size.MK_Accessory_Descent
        }
    }

}


extension NSAttributedString {

    ///获取富文本中附件
    func getAccessory()->MK_Accessory?{
        guard self.string == MK_Accessory.Attribute_PlaceholderStr else { return nil }
        let res : MK_Accessory? = self.getAttributeValue(name: NSAttributedStringKey.init(MK_Accessory.AttributeKeyStr))
        return res
    }
}


