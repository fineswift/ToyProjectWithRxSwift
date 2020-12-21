//
//  Indicator.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/28.
//

import UIKit

class Indicator: NSObject {
    static let shared = Indicator()

    private override init() { }

    lazy var indicatorWindow = UIApplication.shared.windows.first { $0.isKeyWindow }

    lazy var indicator = UIActivityIndicatorView().then {
        $0.style = .large
        $0.color = .link
        $0.hidesWhenStopped = true
    }

    func start() {
        indicatorWindow?.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.size.equalTo(50)
            $0.center.equalToSuperview()
        }

        indicator.startAnimating()
    }

    func stop() {
        DispatchQueue.main.async { [weak self] in
            self?.indicator.stopAnimating()
        }
    }
}
