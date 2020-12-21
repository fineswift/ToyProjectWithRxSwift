//
//  Resource.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/10/05.
//

import Foundation

struct R {
    struct string {
        struct detail { }
    }
}

extension R.string.detail {
    /// 도시이름
    static let cityName: (String?) -> String = { "도시 이름: \($0 ?? "nil")" }
    /// 현재날씨
    static let status: (String?) -> String = { "현재 날씨: \($0 ?? "nil")" }
    /// 기온
    static let temperature: (String?) -> String = { "기    온: \($0 ?? "nil")" }
    /// 위도
    static let lat: (Double?) -> String = { "위    도: \($0.map { String($0) } ?? "nil")" }
    /// 경도
    static let lon: (Double?) -> String = { "경    도: \($0.map { String($0) } ?? "nil")" }
}
