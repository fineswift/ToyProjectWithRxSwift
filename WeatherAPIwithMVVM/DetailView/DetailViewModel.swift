//
//  DetailViewModel.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/18.
//

import Foundation
import RxFlow

class DetailViewModel: ViewModelType, Stepper {
    // MARK: - Stepper
    var steps = PublishRelay<Step>()
    
    // MARK: - Properties
    /// 이전 뷰에서 전달 받은 날씨 정보
    var dataInfo: CityInfo?
    
    init(model: CityInfo) {
        dataInfo = model
    }

    // MARK: - ViewModelType Protocol
    typealias ViewModel = DetailViewModel

    struct Input {
    }

    struct Output {
        let detailInfo: Observable<CityInfo>
    }

    func transform(req: ViewModel.Input) -> ViewModel.Output {
        return Output(detailInfo: Observable.just(dataInfo).compactMap { $0 })
    }
}
