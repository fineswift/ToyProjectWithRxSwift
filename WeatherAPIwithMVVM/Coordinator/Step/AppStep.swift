//
//  AppStep.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/12/21.
//

import RxFlow

enum AppStep: Step {
    /// 메인 화면
    case main
    /// 검색 화면
    case search
    /// 상세보기 화면
    case detail(data: [CityInfo], index: Int)
    /// dismiss
    case dismiss(completion: (() -> Void)?)
}
