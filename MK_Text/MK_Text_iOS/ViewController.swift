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
        let str = NSMutableAttributedString.init(string: "a")
        str.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 20), range: NSRange.init(location: 0, length: str.length))

        let imStr = NSMutableAttributedString.mk_image(im: MK_Image.init(named: "face")!, size: CGSize.init(width: 30, height: 30), alignType: NSMutableAttributedString.AlignType.center)



        str.append(imStr)
        str.append(NSAttributedString.init(string: "0000009999999"))

        ml.text = str
        self.view.addSubview(ml)


    }


}

