//
//  MultiTypeDictionary.swift
//  DemoFabbi
//
//  Created by tientm on 04/02/2024.
//

import Foundation

class MultiTypeDictionary<Root> {
    private var dict: [PartialKeyPath<Root>: Any] = [:]

    // được gọi với các Value bình thường
    subscript<Value>(keyPath: KeyPath<Root, Value>) -> Value? {
        get { dict[keyPath] as? Value }
        set { dict[keyPath] = newValue }
    }

    // được gọi với các optional Value
    subscript<Value>(keyPath: KeyPath<Root, Value?>) -> Value? {
        get { dict[keyPath] as? Value }
        set { dict[keyPath] = newValue }
    }
}
