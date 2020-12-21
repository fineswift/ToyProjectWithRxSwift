//
//  MainViewModel.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/18.
//

import Foundation

enum MainInput {
    case refresh
    case search
    case cellSelect(CityInfo)
    case cellDelete(CityInfo)
}

enum ViewType {
    case detail(CityInfo)
    case search
}

class MainViewModel: ViewModelType {

    let disposeBag = DisposeBag()
    /// 서버에서 받아온 도시 리스트
    var listCellData: [CityInfo] = []
    /// 테이블 뷰에 보여줄 도시 리스트
    let cityRelay = PublishRelay<[CityInfo]>()
    /// 검색한 도시의 id
    let searchCity = PublishSubject<Int>()
    /// 화면 전환 이벤트
    let viewModelRelay = PublishRelay<ViewType>()

    // MARK: - ViewModelType Protocol
    typealias ViewModel = MainViewModel

    struct Input {
        let action: Observable<MainInput>
    }

    struct Output {
        let itemList: Observable<[CityInfo]>
        let viewMove: Observable<ViewType>
    }

    func transform(req: ViewModel.Input) -> ViewModel.Output {
        req.action.bind(onNext: actionProcess).disposed(by: disposeBag)

        searchCity.subscribe(onNext: { [weak self] id in
            guard let `self` = self else { return }
            if self.listCellData.count >= 20 {
                ToastMessage.shared.showToast("저장 가능한 갯수를 초과하였습니다!")
            } else if self.listCellData.contains(where: { data in data.id == id}) {
                ToastMessage.shared.showToast("검색한 도시가 이미 있습니다!")
            } else {
                var array = [id]
                if self.listCellData.count > 0 {
                    self.listCellData.forEach { array.append($0.id!) }
                }
                self.setUpData(array)
            }
        }).disposed(by: disposeBag)

        return Output(itemList: cityRelay.asObservable(),
                      viewMove: viewModelRelay.asObservable())
    }
    
    /// 터치 액션 이벤트
    func actionProcess(action: MainInput) {
        switch action {
        case .refresh:
            if let data = UserDefaults.standard.value(forKey: "CityIdList") as? [Int] {
                setUpData(data)
            }
        case .search:
            self.viewModelRelay.accept(.search)
        case .cellSelect(let city):
            viewModelRelay.accept(.detail(city))
        case .cellDelete(let city):
            guard var data = UserDefaults.standard.value(forKey: "CityIdList") as? [Int] else { return }
            for i in 0..<data.count {
                if data[i] == city.id {
                    data.remove(at: i)
                    break
                }
            }
            UserDefaults.standard.set(data, forKey: "CityIdList")
            setUpData(data)
        }
    }
}

extension MainViewModel {
    /// 데이터 불러오기
    func setUpData(_ cityId: [Int?]) {
        let result: Single<BaseWeatherAPI> = NetworkService.loadData(type: .weather(cityId))

        result.subscribe { [weak self] event in
            guard let `self` = self else { return }
            switch event {
            case .success(let model):
                self.listCellData = [] // 중복방지하면서 갱신하기 위해 리스트 배열 비워주기 (개선 필요)
                model.list?.forEach {
                    self.listCellData.append(model.send($0))
                }
                self.cityRelay.accept(self.listCellData)
                UserDefaults.standard.set(self.listCellData.map { $0.id }, forKey: "CityIdList")
            case .error(let error):
                ToastMessage.shared.showToast(error.localizedDescription)
            }
        }.disposed(by: disposeBag)
    }
}
