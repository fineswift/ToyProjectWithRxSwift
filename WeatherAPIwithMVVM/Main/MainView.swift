//
//  MainView.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/18.
//

import UIKit

class MainView: UIView, UIBasePreView {
    
    // MARK: - Model type implemente
    typealias Model = Void
    
    let disposeBag = DisposeBag()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Objects
    let tableView = UITableView().then {
        $0.register(MainCell.self, forCellReuseIdentifier: "CustomCell")
    }
    var searchButton = UIBarButtonItem()
    
    // MARK: - Methods
    func setupLayout() {
        self.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.rowHeight = 74.5
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
    }
    
    // MARK: - model Dependency Injection
    /// 테이블뷰에 데이터 리스트 보여주기 위함
    func setupDI<T>(observable: Observable<[T]>) -> Self {
        if let cityList = observable as? Observable<[CityInfo]> {
            cityList.bind(to: tableView.rx.items(cellIdentifier: "CustomCell", cellType: MainCell.self)) { row, element, cell in
                cell.mapping(data: element)
            }.disposed(by: disposeBag)
        } else {
            print("Observable Type Error!!!(미구현): MainView")
        }
        return self
    }

    /// 터치 액션
    @discardableResult
    func setupDI<T>(generic: PublishRelay<T>) -> Self {
        if let relay = generic as? PublishRelay<MainInput> {
            searchButton.rx.tap
                .map { .search }
                .bind(to: relay)
                .disposed(by: disposeBag)
            
            tableView.rx.modelSelected(CityInfo.self)
                .map { .cellSelect($0) }
                .bind(to: relay)
                .disposed(by: disposeBag)
            
            tableView.rx.modelDeleted(CityInfo.self)
                .map { .cellDelete($0) }
                .bind(to: relay)
                .disposed(by: disposeBag)
        } else {
            print("PublishRelay Type Error!!!(미구현): MainView")
        }
        return self
    }
}
