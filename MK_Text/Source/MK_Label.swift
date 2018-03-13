//
//  MK_Label.swift
//  MK_Text
//
//  Created by MBP on 2018/1/26.
//  Copyright © 2018年 MBP. All rights reserved.
//

import CoreGraphics
#if os(macOS)
    import AppKit
#else
    import UIKit
#endif



public class MK_Label:MK_AsyncView{
    
    
    static let AttributeKey = "MK_Label_AttributeKey"

    ///富文本
    public var attributeStr:NSAttributedString? {
        didSet{
            guard let str = attributeStr else {
                text = nil
                return
            }
            text = NSMutableAttributedString.init(attributedString: str)
        }
    }

    ///富文本
    var text:NSMutableAttributedString? {
        didSet{
            if text != nil{
                weak var weakSelf = self
                text?.addAttributes([NSAttributedStringKey.init(MK_Label.AttributeKey) : weakSelf ?? 0], range: text!.range)
            }
            if self.window != nil {
                self.draw(self.bounds)
            }
        }
    }

    
    ///布局
    lazy var layout = { () -> MK_TextLayout in
        let res = MK_TextLayout()
        res.delegate = self
        return res
    }()
    ///点击
    lazy var tapManager = MK_TapManager()
    
    ///重制
    public func reDraw(){
        guard self.window != nil else { return }
        self.draw(self.bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLabel()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpLabel()
    }
    
    fileprivate func setUpLabel(){
        self.setNewTask(task: labelTask)
    }
    
    private var needSize:CGSize!
    ///绘制任务
    fileprivate lazy var labelTask = { () -> MK_AsyncTask in
        var task = MK_AsyncTask()
        
        task.disPlayBlock = {[weak self] ()-> CGImage? in
            
            guard self != nil else { return nil }
            guard let str = self?.text else { return nil }

            let size = self!.getLabelSize()
            let (arr,newSize) = self!.layout.layout(str: str, drawSize: size)
            
            var context:CGContext?
            let block = { ()->CGContext? in
                
                let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
                let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
                let res = CGContext(data: nil, width: Int(newSize.width), height: Int(newSize.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
                return res
            }
            
            if self!.isAsync {
                #if os(macOS)
                    let sema = DispatchSemaphore.init(value: 0)
                    OperationQueue.main.addOperation({
                        context = block()
                        sema.signal()
                    })
                    _ = sema.wait(timeout: DispatchTime.now()+10)
                #else
                    context = block()
                #endif
                
            }else {
                context = block()
            }
            if context == nil { return nil }
            
            for item in arr{
                item.drawInContext(context:context!, size: newSize)
            }
            let im = context!.makeImage()

            return im
        }
        return task
    }()
    
    
    fileprivate func getLabelSize()->CGSize{
        if !isAsync {
            return self.bounds.size
        }
        var size:CGSize = CGSize.zero
        let sema = DispatchSemaphore.init(value: 0)
        OperationQueue.main.addOperation {
            size = self.bounds.size
            sema.signal()
        }
        _ = sema.wait(timeout: DispatchTime.now()+10)
        
        return size
    }
    
}

#if os(macOS)
    
    extension MK_Label {
        public override func mouseDown(with event: NSEvent) {
            let location = self.convert(event.locationInWindow, from: self.window?.contentView)
            tapManager.tapDownAt(point: CGPoint.init(x: location.x, y: self.bounds.size.height - location.y),view: self)
        }
        
        public override func mouseUp(with event: NSEvent) {
            let location = self.convert(event.locationInWindow, from: self.window?.contentView)
            tapManager.tapUpAt(point: CGPoint.init(x: location.x, y: self.bounds.size.height - location.y),view: self)
        }
        
        public override func viewDidMoveToWindow() {
            
            if self.translatesAutoresizingMaskIntoConstraints == false {
                self.superview?.layoutSubtreeIfNeeded()
                if self.frame.size.width == 0 {
                    let wi = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0)
                    self.addConstraints([wi])
                }
                if self.frame.size.height == 0 {
                    let hi = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0)
                    self.addConstraints([hi])
                }
            }
        }
    }
    
#else
    extension MK_Label {
        public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let location = touches.first?.location(in: self) else { return }
            tapManager.tapDownAt(point: location,view: self)
        }
        public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let location = touches.first?.location(in: self) else { return }
            tapManager.tapUpAt(point: location,view: self)
        }
        public override func didMoveToWindow() {
            
            if self.translatesAutoresizingMaskIntoConstraints == false {
                self.superview?.layoutIfNeeded()
                if self.frame.size.width == 0 {
                    let wi = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0)
                    self.addConstraints([wi])
                }
                if self.frame.size.height == 0 {
                    let hi = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0)
                    self.addConstraints([hi])
                }
            }
            
        }
        
    }
#endif

extension MK_Label : MK_TextLayout_Delegate {

    func getLinesSuperView() -> MK_View {
        return self
    }

    ///进行自动约束Size
    func getLayoutDrawSize(newSize: CGSize) {
        let block = {
            self.translatesAutoresizingMaskIntoConstraints = false

            guard abs(newSize.width - self.frame.size.width) > 1 || abs(newSize.height - self.frame.size.height) > 1 else {
                return
            }

            for item in self.constraints {
                if let conOb = item.firstItem as? NSObject ,conOb == self ,(item.firstAttribute == .width || item.firstAttribute == .height){
                    self.removeConstraint(item)
                }
            }
            let wi = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: newSize.width)
            
            let hi = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: newSize.height)
            self.addConstraints([wi,hi])
            self.frame.size = newSize
        }

        if Thread.current.isMainThread {
            block()
        }else{
            OperationQueue.main.addOperation(block)
        }
    }
    
}
