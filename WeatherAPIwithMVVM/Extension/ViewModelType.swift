//
//  ViewModelType.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/18.
//

import Foundation

protocol ViewModelType: ViewModel {
    associatedtype ViewModel: ViewModelType

    associatedtype Input

    associatedtype Output

    func transform(req: ViewModel.Input) -> ViewModel.Output
}
