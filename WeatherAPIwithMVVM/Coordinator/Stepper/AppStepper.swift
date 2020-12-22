//
//  AppStepper.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/12/21.
//

import RxFlow

class AppStepper: Stepper {
    static let shared = AppStepper()
    
    let steps = PublishRelay<Step>()
    
    var initialStep: Step {
        AppStep.main
    }
}
