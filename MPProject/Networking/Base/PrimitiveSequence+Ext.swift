//
//  PrimitiveSequence+Ext.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import RxSwift

public extension PrimitiveSequence {
    /// Run observable in background thread and back to mainthread
    func runInThread(
        mainScheduler: SchedulerType = MainScheduler.instance,
        bgScheduler: SchedulerType = ConcurrentDispatchQueueScheduler.init(qos: .background)
    ) -> PrimitiveSequence<Trait, Element> {
        return self.subscribeOn(bgScheduler)
            .observeOn(mainScheduler)
    }
}
