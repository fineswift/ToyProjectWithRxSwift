//
//  InitFlow.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/12/21.
//

import RxFlow

class InitFlow: Flow {
    static let `shared`: InitFlow = InitFlow()
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController = UINavigationController().then {
        $0.setNavigationBarHidden(false, animated: false)
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .main:
            return navigateToMain()
        case .search:
            return navigateToSearch()
        case .detail(let data, let index):
            return navigateToDetail(data, index)
        case .dismiss(let completion):
            self.rootViewController.presentedViewController?.dismiss(animated: true, completion: completion)
            return .none
        }
    }
}

extension InitFlow {
    private func navigateToMain() -> FlowContributors {
        FlowSugar(MainViewModel(), MainViewController.self)
            .navigationItem(with: {
                $0.title = "Weather"
            })
            .oneStepPushBy(self.rootViewController)
    }
    
    private func navigateToSearch() -> FlowContributors {
        FlowSugar(viewModel: SearchViewModel())
            .presentable(SearchViewController.self)
            .oneStepModalPresent(rootViewController, .automatic, true)
        
        // MARK: - FlowSugar 사용 X
//        let VC = SearchViewController.instantiate(withViewModel: SearchViewModel())
//        self.rootViewController.present(VC, animated: true)
//        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VC.viewModel))
    }
    
    private func navigateToDetail(_ data: [CityInfo], _ index: Int) -> FlowContributors {
        FlowSugar(DetailViewModel(model: data, index: index), DetailViewController.self)
            .navigationItem(with: {
                $0.title = "Detail"
            })
            .oneStepPushBy(self.rootViewController)
        
        // MARK: - FlowSugar 사용 X
//        let viewController = DetailViewController.instantiate(withViewModel: DetailViewModel(model: data))
//        viewController.title = "Detail"
//        self.rootViewController.pushViewController(viewController, animated: true)
//        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController.viewModel))
    }
}
