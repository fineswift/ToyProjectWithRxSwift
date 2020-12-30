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
    let disposeBag = DisposeBag()
    let dataInfoRelay = BehaviorRelay<CityInfo?>(value: nil)
    var dataInfoList: [CityInfo]
    var currentIndex: Int
    
    init(model: [CityInfo], index: Int) {
        dataInfoList = model
        currentIndex = index
        dataInfoRelay.accept(model[index])
    }

    // MARK: - ViewModelType Protocol
    typealias ViewModel = DetailViewModel

    struct Input {
        let buttonTapAction: Observable<Bool>
    }

    struct Output {
        let detailInfo: Observable<CityInfo?>
    }

    func transform(req: ViewModel.Input) -> ViewModel.Output {
        req.buttonTapAction
            .bind(onNext: moveToCityInfo(_:))
            .disposed(by: disposeBag)
        
        return Output(detailInfo: dataInfoRelay.asObservable())
    }
    
    /// 처음에 받아온 currentIndex와 [CityInfo] 갯수 비교
    func moveToCityInfo(_ isNext: Bool) {
        if isNext && currentIndex < dataInfoList.count - 1 {
            currentIndex += 1
        } else if !isNext && currentIndex > 0 {
            currentIndex -= 1
        }
        dataInfoRelay.accept(dataInfoList[currentIndex])
    }
}
