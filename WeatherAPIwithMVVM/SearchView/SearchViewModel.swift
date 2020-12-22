//
//  SearchViewModel.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/18.
//

import Foundation
import RxFlow

enum SearchInput {
    case searchText(String)
    case modelSelect(List)
}

class SearchViewModel: ViewModelType, Stepper {
    // MARK: - Stepper
    var steps = PublishRelay<Step>()
    
    // MARK: - Properties
    /// 서버에서 받아온 50개의 도시 리스트
    var cityNames: [List] = []
    /// 테이블 뷰 셀에 보여줄 데이터 리스트
    let cityListRelay = PublishRelay<[List]>()
    let disposeBag = DisposeBag()
    
    
    // MARK: - ViewModelType Protocol
    typealias ViewModel = SearchViewModel
    
    struct Input {
        let dataRequestTrigger: Observable<Void>
        let actionRelay: PublishRelay<SearchInput>
    }
    
    struct Output {
        let cityList: Observable<[List]>
    }

    func transform(req: ViewModel.Input) -> ViewModel.Output {
        req.dataRequestTrigger.subscribe(onNext: setupData).disposed(by: disposeBag)
        
        req.actionRelay.subscribe(onNext: action).disposed(by: disposeBag)
        
        return Output(cityList: cityListRelay.asObservable())
    }
}

extension SearchViewModel {
    func setupData() {
        let result: Single<CityList> = NetworkService.loadData(type: .cityList)
        
        result.subscribe { [weak self] event in
            guard let `self` = self else { return }
            switch event {
            case .success(let model):
                model.list.forEach {
                    self.cityNames.append($0)
                }
                self.cityListRelay.accept(self.cityNames)
            case .error(let error):
                ToastMessage.shared.showToast(error.localizedDescription)
            }
        }.disposed(by: disposeBag)

    }
    
    func action(_ type: SearchInput) {
        switch type {
        case .searchText(let text):
            if text == "" {
                cityListRelay.accept(cityNames)
            } else {
                cityListRelay.accept(cityNames.filter { $0.name.lowercased().contains(text.lowercased()) })
            }
        case .modelSelect(let model):
            AlertManager.shared.showAlert(alertTitle: "추가",
                                          alertMessage: "도시를 추가하겠습니까?",
                                          cancelTitle: "취소",
                                          okTitle: "추가",
                                          input: model.name,
                                          completion: { [weak self] in
//                                            self?.vc?.viewModel.searchCity.onNext(model.id)
                                            
                                            
            })
        }
    }
}
