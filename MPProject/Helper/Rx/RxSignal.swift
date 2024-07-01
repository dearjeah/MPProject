//
//  RxSignal.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import Foundation
import RxSwift

/// signal from vm to vc
@propertyWrapper
public class RxSignal<Value> {

    private var relay = PublishSubject<Value>()

    public var wrappedValue: Observable<Value>
    public var projectedValue: AnyObserver<Value>

    public init() {
        projectedValue = .init(relay)
        wrappedValue = relay.asObservable()
    }

}
