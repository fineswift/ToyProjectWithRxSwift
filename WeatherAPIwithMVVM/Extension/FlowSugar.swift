//
//  FlowSugar.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/12/21.
//

import RxFlow

typealias ViewModelStepper = ViewModelType & Stepper
typealias ViewModelController = ViewModelProtocol & UIViewController

class FlowSugar<VM, VC>: NSObject where VM: ViewModelStepper, VC: ViewModelController {
    var vm: VM!
    var vc: VC?
    
    override init() {
        fatalError("init() has not been supported")
    }
    
    init(viewModel vm: VM) {
        self.vm = vm
        super.init()
    }

    init(_ flow: Flow, _ step: Step) {
    }
    
    init(_ vm: VM, _ vc: VC.Type) {
        self.vm = vm
        self.vc = VC().then {
            $0.viewModel = vm as? VC.ViewModelType
        }
        super.init()
    }
    
    func presentable(_ vc: VC.Type) -> Self {
        self.vc = VC().then {
            $0.viewModel = vm as? VC.ViewModelType
        }
        return self
    }
    
    func navigationItem(with block: @escaping (UIViewController) -> Void) -> Self {
        if let vc = self.vc {
            block(vc)
        }
        return self
    }
    
    func getViewController() -> VC? {
        if let vc = self.vc {
            return vc
        } else {
            return nil
        }
    }
    
    func setVCPorperty(viewControllerBlock block: @escaping (VC) -> Void) -> Self {
        if let vc = self.vc {
            block(vc)
        }
        return self
    }
    
    func oneStepPushBy(_ navi: UINavigationController, block: ((UINavigationController, VC) -> Void)? = nil) -> FlowContributors {
        if let vc = self.vc {
            navi.pushViewController(vc, animated: true)
            block?(navi, vc)
            return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
        }
        return .none
    }
    
    func oneStepModalPresent(_ parentVC: UIViewController, _ modalStyle: UIModalPresentationStyle = .fullScreen, _ animated: Bool = true) -> FlowContributors {
        if let vc = self.vc {
            vc.modalPresentationStyle = modalStyle
            parentVC.present(vc, animated: animated)
            return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
        }
        return .none
    }
    
//    func oneStepModalPresentMakeNavi(_ parentVC: UIViewController, _ modalStyle: UIModalPresentationStyle = .fullScreen, _ animated: Bool = true) -> FlowContributors {
//        if let vc = self.vc {
//            let navigationController = UINavigationController(rootViewController: vc)
//            navigationController.modalPresentationStyle = .fullScreen
//            parentVC.present(navigationController, animated: animated)
//            return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
//        }
//        return .none
//    }
//
//    func oneStepModalPresentMakeNavi(_ parentVC: UIViewController, _ modalStyle: UIModalPresentationStyle = .fullScreen, _ animated: Bool = true, block: @escaping (UINavigationController, VC) -> Void) -> FlowContributors {
//        if let vc = self.vc {
//            let navigationController = UINavigationController(rootViewController: vc)
//            navigationController.modalPresentationStyle = .fullScreen
//            parentVC.present(navigationController, animated: animated)
//            block(navigationController, vc)
//            return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
//        }
//        return .none
//    }
}
