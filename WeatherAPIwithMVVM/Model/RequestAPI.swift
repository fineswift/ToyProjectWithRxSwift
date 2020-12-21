//
//  RequestAPI.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/18.
//

import Foundation

enum URLType {
    /// ViewController
    case weather([Int?])
    /// SearchViewController
    case cityList
    /// 베이스 url주소
    var baseURL: String {
        return "http://api.openweathermap.org/data/2.5/"
    }
    /// 고유 id
    var appId: String {
         "e56874130e02399e6fa15ff39256d818&units=metric"
    }
    /// 타입에 따라 url주소 다르게
    var makeURL: String {
        switch self {
        case .weather(let cityId):
            // [Int?] -> [Int] -> [String] -> "string1,string2,string3..."
            return "\(baseURL)group?id=\(cityId.compactMap{ $0 }.map{ String($0) }.joined(separator: ","))&appid=\(appId)"
        case .cityList:
            return "\(baseURL)find?lat=37.57&lon=126.98&cnt=50&appid=\(appId)"
        }
    }
}

struct NetworkService {
    /// 데이터 통신 Single형태로
    static func loadData<T: Codable>(type: URLType) -> Single<T> {
        guard let url = URL(string: type.makeURL) else { return Observable.error(NSError(domain: "url generation error", code: -1, userInfo: nil)).asSingle() }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return Single<T>.create { (single) -> Disposable in
            Indicator.shared.start()
            let task = URLSession.shared.dataTask(with: request) { data, responds, error in
                if let error = error {
                    single(.error(error))
                    return
                }
                if let model: T = try? JSONDecoder().decode(T.self, from: data ?? Data()) {
                    single(.success(model))
                } else {
                    DispatchQueue.main.async {
                        ToastMessage.shared.showToast("Decoding Error!!!")
                        Indicator.shared.stop()
                    }
                }
            }
            task.resume()
            return Disposables.create {
                Indicator.shared.stop()
                task.cancel()
            }
        }
    }
}
