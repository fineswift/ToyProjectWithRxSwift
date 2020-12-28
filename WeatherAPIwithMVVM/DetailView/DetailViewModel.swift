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
    var dataInfo: CityInfo
    
    init(model: CityInfo) {
        dataInfo = model
    }

    // MARK: - ViewModelType Protocol
    typealias ViewModel = DetailViewModel

    struct Input {
        let nextModel: PublishRelay<Void>
        let beforeModel: PublishRelay<Void>
    }

    struct Output {
        let detailInfo: Observable<CityInfo>
    }

    func transform(req: ViewModel.Input) -> ViewModel.Output {
        req.nextModel
            .subscribe(onNext: { _ in
                ToastMessage.shared.showToast("Test 다음 버튼")
            })
            .disposed(by: disposeBag)
        
        req.beforeModel
            .subscribe(onNext: { _ in
                ToastMessage.shared.showToast("Test 이전 버튼")
            })
            .disposed(by: disposeBag)
        
        return Output(detailInfo: Observable.just(dataInfo))
    }
}
