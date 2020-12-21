//
//  File.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/21.
//

import Foundation

public protocol UIBasePreView {
    associatedtype Model
    typealias Models = [Model]
}

extension UIBasePreView {
    func setupDI(observable: Observable<Self.Model>) {}
    func setupDI(observable: Observable<Self.Models>) {}

    @discardableResult
    func setupDI<T>(observable: Observable<[T]>) -> Self { return self }
    @discardableResult
    func setupDI<T>(generic: PublishRelay<T>) -> Self { return self }
}
