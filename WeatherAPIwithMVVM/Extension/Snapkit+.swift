//
//  Snapkit+.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/12/28.
//

import UIKit

extension ConstraintMakerRelatable {
    @discardableResult
    public func equalToSafeAreaAuto(_ view: UIView, _ file: String = #file, _ line: UInt = #line) -> ConstraintMakerEditable {
        if #available(iOS 11.0, *) {
            return self.equalTo(view.safeAreaLayoutGuide, file, line)
        }
        return self.equalToSuperview()
    }
}
