//
//  WeatherData.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/18.
//

import UIKit

// MARK: - CityInfo
struct CityInfo: Codable {
    let id: Int?
    let name: String? // 도시이름
    let status: String? // 날씨 상태
    let temperature: String? // 기온
    let lon: Double? // 경도
    let lat: Double? // 위도
    var image: UIImage? { // status값에 따라 이미지를 다르게 보여줌
        var image = UIImage()
        if status != nil {
            switch status {
            case "Rain", "Mist", "Drizzle", "Thunderstorm":
                image = UIImage(named: "rainy.png")!
            case "Clouds", "Haze":
                image = UIImage(named: "cloudy.png")!
            case "Blizzard":
                image = UIImage(named: "blizzard.png")!
            case "Snow":
                image = UIImage(named: "snow.png")!
            default:
                image = UIImage(named: "sunny.png")!
            }
        }
        return image
    }
}

// MARK: - WeatherInfo
/// 검색한 도시의 날씨정보
struct BaseWeatherAPI: Codable {
    let cnt : Int?
    let list : [WeatherInfo]?

    enum CodingKeys: String, CodingKey {
        case cnt = "cnt"
        case list = "list"
    }

    /// WeatherInfo형태의 data를 받아서 CityInfo형태로 return
    func send(_ data: WeatherInfo) -> CityInfo {
        return CityInfo(id: data.id,
                        name: data.name,
                        status: data.weather?.first?.main,
                        temperature: data.main?.temp.map { String($0 )},
                        lon: data.coord?.lon,
                        lat: data.coord?.lat)
    }
}

struct WeatherInfo : Codable {
    let coord : Coord?
    let weather : [Weather]?
    let main : Main?
    let id : Int?
    let name : String?

    enum CodingKeys: String, CodingKey {
        case coord = "coord"
        case weather = "weather"
        case main = "main"
        case id = "id"
        case name = "name"
    }
}

struct Coord : Codable {
    let lon : Double?
    let lat : Double?

    enum CodingKeys: String, CodingKey {
        case lon = "lon"
        case lat = "lat"
    }
}

struct Weather : Codable {
    let main : String?

    enum CodingKeys: String, CodingKey {
        case main = "main"
    }
}

struct Main : Codable {
    let temp : Double?

    enum CodingKeys: String, CodingKey {
        case temp = "temp"
    }
}

// MARK: - CityList
/// 서울지역 주변 50개 도시 리스트
struct CityList : Codable {
    let list : [List]

    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}

struct List : Codable {
    let id: Int
    let name : String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
