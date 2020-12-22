//
//  ViewController.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/18.
//

import UIKit

class MainViewController: UIViewController, ViewModelProtocol {
    typealias ViewModel = MainViewModel

    // MARK: - ViewModelProtocol
    var viewModel: ViewModel!

    // MARK: - Properties
    let actionRelay = PublishRelay<MainInput>()
    let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        bindingViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actionRelay.accept(.refresh)
    }

    // MARK: - View
    let subView = MainView()

    func setupLayout() {
        self.view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        navigationItem.rightBarButtonItem = subView.searchButton
    }

    // MARK: - Binding
    func bindingViewModel() {
        let res = viewModel.transform(req: ViewModel.Input(action: actionRelay.asObservable()))

        subView
            .setupDI(observable: res.itemList)
            .setupDI(generic: actionRelay)
    }

    // MARK: - Methods
}
