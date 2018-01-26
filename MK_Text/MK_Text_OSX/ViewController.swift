//
//  ViewController.swift
//  MK_Text_OSX
//
//  Created by MBP on 2018/1/25.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let lay = MK_TextLayout()
        let size = CGSize.init(width: 30, height: 300)
        let str = NSMutableAttributedString.init(string: "gfiyusdg;olaujfusgbahu,eipomfjjsbgfw;ghiawq3")
        print(lay.layout(str: str, drawSize: size))





        let MK_TV = MK_AsyncView.init(frame:  CGRect.init(x: 0, y: 0, width: 300, height: 300))
        var task = MK_AsyncTask()
        task.disPlayBlock = { (context,size)->() in

            let str = "1234567890sghbaxsjklcnrlmziksssfhgh9uei"
            let attStr = NSMutableAttributedString.init(string: str)

            attStr.addAttribute(NSAttributedStringKey.font, value: NSFont.systemFont(ofSize: 18), range: NSRange.init(location: 0, length: attStr.length))

            let imStr = NSMutableAttributedString.mk_image(im: MK_Image.init(named: NSImage.Name.init("face"))!, size: CGSize.init(width: 30, height: 30))

            attStr.append(imStr)

            let lasStr = NSMutableAttributedString.init(string: "aaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa")
            attStr.append(lasStr)


            let lasStr1 = NSMutableAttributedString.init(string: "hhhhhhhhhhhhhhh hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh")
            lasStr1.addAttribute(NSAttributedStringKey.init("hh"), value: 1, range: NSRange.init(location: 0, length: lasStr1.length))
            attStr.append(lasStr1)

            let imStr1 = NSMutableAttributedString.mk_image(im: MK_Image.init(named: NSImage.Name.init("face"))!, size: CGSize.init(width: 60, height: 60))
            attStr.append(imStr1)

            let path = NSBezierPath.init(rect: NSRect.init(x: 0, y: 0, width: 300, height: 300))

            let framesetter = CTFramesetterCreateWithAttributedString(attStr as CFAttributedString)
            let rang = CFRange.init(location: 0, length: attStr.length)
            let frame = CTFramesetterCreateFrame(framesetter, rang, path.CGPath, nil)
            CTFrameDraw(frame, context)


            //            let rex = attStr.boundingRect(with: NSSize.init(width: 300, height: 300), options: NSString.DrawingOptions.usesLineFragmentOrigin)
            //
            //
            //            print(rex)



            let lines = CTFrameGetLines(frame) as NSArray

            print("共有\(lines.count)行")

            let ctLinesArr = lines as! Array<CTLine>
            var oriArr = [CGPoint](repeating: CGPoint.zero, count:ctLinesArr.count)
            let range = CFRange.init(location: 0, length: 0)
            CTFrameGetLineOrigins(frame, range, &oriArr)

            /// 绘制行
            for item in lines{
                var lineAscent = CGFloat()
                var lineDescent = CGFloat()
                var lineLeading = CGFloat()

                CTLineGetTypographicBounds(item as! CTLine, &lineAscent, &lineDescent, &lineLeading)
                let runArr = CTLineGetGlyphRuns(item as! CTLine) as NSArray

                print("\(lineAscent)  \(lineDescent)  \(lineLeading)")

                for (index,run) in runArr.enumerated() {
                    var runAscent = CGFloat()
                    var runDescent = CGFloat()
                    let attributes = CTRunGetAttributes(run as! CTRun) as NSDictionary


                    if  index > oriArr.count - 1 { return }
                    let lineOrigin = oriArr[index]
                    
                    print(lineOrigin)

                    let width = CTRunGetTypographicBounds(run as! CTRun, CFRange.init(location: 0, length: 0), &runAscent, &runDescent, nil)
                    let runRect = CGRect.init(x: lineOrigin.x + CTLineGetOffsetForStringIndex(item as! CTLine, CTRunGetStringRange(run as! CTRun).location, nil), y: lineOrigin.y - runDescent, width: CGFloat(width), height: runAscent + runDescent)


                    let acc = attributes[MK_Accessory.MK_Accessory_AttributeKeyStr] as? MK_Accessory

                    if acc != nil{

                        switch acc!.content! {
                        case .image(let (im, si)):
                            let imRect = CGRect.init(x: runRect.origin.x, y: lineOrigin.y - runDescent, width: si.width, height: si.height)
                            context.draw((im.CGImage), in: imRect)
                        case .view(_, _): break
                        }


                    }
                }
            }
        }

        MK_TV.setNewTask(task: task)
        //self.view.addSubview(MK_TV)

    }
}

