//
//  ToastMessage.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/28.
//

import UIKit

final class ToastMessage: NSObject {
    static let shared = ToastMessage()

    private override init() { }

    lazy var toastWindow = UIApplication.shared.keyWindowInConnectedScenes

    lazy var toastLabel = UILabel().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.alpha = 1.0
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    func showToast(_ message: String) {
        toastLabel.text = message
        toastWindow?.addSubview(toastLabel)

        toastLabel.frame = CGRect(x: 30.0, y: UIScreen.main.bounds.height - 100.0, width: UIScreen.main.bounds.width - 2 * 30.0, height: 35.0)

        UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseInOut, animations: { [weak self] in
            self?.toastLabel.alpha = 0.0
        }, completion: { [weak self] _ in
            self?.toastLabel.alpha = 1.0
            self?.toastLabel.removeFromSuperview()
        })
    }
}
