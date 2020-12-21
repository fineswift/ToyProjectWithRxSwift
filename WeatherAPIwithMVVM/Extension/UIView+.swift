//
//  UIView+.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/18.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        _ = views.map { self.addSubview($0) }
    }
}
