//
//  ViewController.swift
//  MK_Text_OSX
//
//  Created by MBP on 2018/1/25.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Cocoa
import SnapKit

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let ml = MK_Label()
        //ml.isAsync = true

        let str = NSMutableAttributedString.init(string: "1234567890")
        str.addAttribute(NSAttributedStringKey.font, value: NSFont.systemFont(ofSize: 36), range: NSRange.init(location: 0, length: str.length))

        ml.text = str
        ml.isAutoLayoutSize = true
        self.view.addSubview(ml)

        ml.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }

    }
}

