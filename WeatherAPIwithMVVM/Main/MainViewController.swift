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

        navigationItem.title = "Weather"
        navigationItem.rightBarButtonItem = subView.searchButton
    }

    // MARK: - Binding
    func bindingViewModel() {
        let res = viewModel.transform(req: ViewModel.Input(action: actionRelay.asObservable()))

        res.viewMove.bind(onNext: viewMoveProcess).disposed(by: disposeBag)

        // output
        subView.setupDI(observable: res.itemList)

        // input
        subView.setupDI(generic: actionRelay)
    }

    // MARK: - Methods
    func viewMoveProcess(viewType: ViewType) {
        switch viewType {
        case .detail(let city):
            let nextVC = DetailViewController().then {
                $0.viewModel = DetailViewModel(model: city)
            }
            UIApplication.shared.topViewController?.navigationController?.pushViewController(nextVC, animated: true)
        case .search:
            let nextVC = SearchViewController.instantiate(withViewModel: SearchViewModel(viewController: self))
            UIApplication.shared.topViewController?.present(nextVC, animated: true)
        }
    }
}
