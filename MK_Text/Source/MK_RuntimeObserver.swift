//
//  MK_RuntimeObserver.swift
//  MK_Text
//
//  Created by MBP on 2018/1/22.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Foundation


fileprivate func ObserverRunTimeBeforeWaiting(){
    OperationQueue.main.addOperation {
        for op in DrawOperationSet{
            MK_OperationQueue.addOperation(op)
        }
        DrawOperationSet.removeAll()
    }
}

fileprivate var DrawOperationSet:Set<Operation> = Set.init()

func  DrawOPSetAddOperation(op:Operation){
    OperationQueue.main.addOperation {
        MK_OperationQueue.addOperation {
            DrawOperationSet.insert(op)
        }
    }
}

///全局串行队列~
let MK_OperationQueue:OperationQueue = { () -> OperationQueue in
    let res = OperationQueue.init()
    res.maxConcurrentOperationCount = 1
    return res
}()

fileprivate var set = 1

class MK_RunTimeRuntimeObserver{

    static let share = { () -> MK_RunTimeRuntimeObserver in
        let res = MK_RunTimeRuntimeObserver()
        let runloop = CFRunLoopGetMain()

        let observer = CFRunLoopObserverCreate(CFAllocatorGetDefault().takeUnretainedValue(),
                                               1 << 5 ,
                                               true,
                                               0xFFFFFF,
                                               { (ob, active, info) in
                                                ObserverRunTimeBeforeWaiting()
        },
                                               nil)
        CFRunLoopAddObserver(runloop, observer, CFRunLoopMode.commonModes)
        return res
    }()
}

