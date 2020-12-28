//
//  Alert.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/25.
//

import UIKit

final class AlertManager: NSObject {
    static let shared = AlertManager()

    private override init() { }

    /// Title, Message, CnacelButtonTitle, OkButtonTitle, Input?, completion
    func showAlert(alertTitle: String, alertMessage: String, cancelTitle: String, okTitle: String, input: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: alertTitle, message: "\(input ?? "")\(alertMessage)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .destructive, handler: nil)
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: { _ in
            AppStepper.shared.steps.accept(AppStep.dismiss(completion: completion))
        })

        alert.addAction(cancelAction)
        alert.addAction(okAction)

        UIApplication.shared.topViewController?.present(alert, animated: true, completion: nil)
    }
}
