//
//  DetailViewController.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/18.
//

import UIKit

class DetailViewController: UIViewController, ViewModelProtocol {
    typealias ViewModel = DetailViewModel

    // MARK: - ViewModelProtocol
    var viewModel: ViewModel!

    // MARK: - Properties
    let buttonActionTrigger = PublishRelay<Bool>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        bindingViewModel()
    }

    // MARK: - View
    let subView = DetailView()

    func setupLayout() {
        self.view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Binding
    func bindingViewModel() {
        let res = viewModel.transform(req: ViewModel.Input(buttonTapAction: buttonActionTrigger.asObservable()))

        subView
            .setupDI(observable: res.detailInfo)
            .setupDI(buttonAction: buttonActionTrigger)
    }

    // MARK: - Methods
}
