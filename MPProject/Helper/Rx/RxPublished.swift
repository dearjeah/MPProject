//
//  RxPublished.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import RxSwift
import RxRelay
/// wraps a raw type property with BehaviourRelay, similar to Combine @Published
@propertyWrapper
public class RxPublished<Value> {
    public var projectedValue: Observable<Value> { relay.asObservable() }
    public var wrappedValue: Value { didSet { valueDidChange() } }

    private lazy var relay = BehaviorRelay<Value>(value: wrappedValue)

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    private func valueDidChange() {
        relay.accept(wrappedValue)
    }
}
