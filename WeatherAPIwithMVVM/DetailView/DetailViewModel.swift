//
//  DetailViewModel.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/18.
//

import Foundation

class DetailViewModel: ViewModelType {
    /// 이전 뷰에서 전달 받은 날씨 정보
    let dataInfo: CityInfo
    
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
        return Output(detailInfo: Observable.just(dataInfo))
    }
}
