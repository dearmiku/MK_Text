//
//  ViewController.swift
//  MK_Text_iOS
//
//  Created by MBP on 2018/1/25.
//  Copyright © 2018年 MBP. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        let ml = MK_Label()
        ml.frame = CGRect.init(x: 0, y: 100, width: 100, height: 100)
        let str = NSMutableAttributedString.init(string: "miku")
        str.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 20), range: NSRange.init(location: 0, length: str.length))


        let imStr = NSMutableAttributedString.mk_image(im: UIImage.init(named: "face")!, size: CGSize.init(width: 30, height: 30), alignType: NSMutableAttributedString.AlignType.top)
        str.append(imStr)



        let tap = NSMutableAttributedString.init(string: "可点击字符")
        let response = MK_TapResponse.init(highlitedBlock: { (str) -> [NSAttributedStringKey : Any]? in
            return [NSAttributedStringKey.foregroundColor : UIColor.red]
        }) { (str, range) in
            print("点击字符串~")
        }
        tap.addTapAttr(response: response, range: nil)
        str.append(tap)


//        let v = UIButton.init(type: UIButtonType.system)
//        v.backgroundColor = UIColor.red
//        let viewStr = NSMutableAttributedString.mk_view(view: v, superView: ml, size: CGSize.init(width: 50, height: 50))
//        str.append(viewStr)

        let imStr2 = NSMutableAttributedString.mk_image(im: UIImage.init(named: "face")!, size: CGSize.init(width: 50, height: 50), alignType: NSMutableAttributedString.AlignType.bottom)
        str.append(imStr2)



        ml.text = str
        self.view.addSubview(ml)
    }
}

