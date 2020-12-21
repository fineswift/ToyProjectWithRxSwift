//
//  SearchViewViewController.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/18.
//

import UIKit

class SearchViewController: UIViewController, ViewModelProtocol {
    typealias ViewModel = SearchViewModel
    
    // MARK: - ViewModelProtocol
    var viewModel: ViewModel!
    
    // MARK: - Properties
    let requestTrigger = PublishRelay<Void>()
    let actionRelay = PublishRelay<SearchInput>()
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bindingViewModel()
        
        requestTrigger.accept(())
    }
    
    // MARK: - View
    let subView = SearchView()
    
    func setupLayout() {
        self.view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    func bindingViewModel() {
        let res = viewModel.transform(req: ViewModel.Input(
                                        dataRequestTrigger: requestTrigger.asObservable(),
                                        actionRelay: actionRelay))
        
        // output
        subView.setupDI(observable: res.cityList.asObservable())
        
        // input
        subView.setupDI(generic: actionRelay)
    }
    
    // MARK: - Methods
}
