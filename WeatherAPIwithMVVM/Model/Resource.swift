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
        struct Toast {}
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

extension R.string.Toast {
    /// 갯수 제한
    static let numberLimit = "저장 가능한 갯수를 초과하였습니다!"
    /// 중복된 도시
    static let duplicateID = "검색한 도시가 이미 있습니다!"
}
