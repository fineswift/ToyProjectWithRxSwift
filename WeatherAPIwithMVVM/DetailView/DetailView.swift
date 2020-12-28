//
//  DetailView.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/18.
//

import UIKit

class DetailView: UIView, UIBasePreView {
    let disposeBag = DisposeBag()

    // MARK: - Model type implemente
    typealias Model = Void

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Objects
    /// 날씨 상태 이미지
    let imgView = UIImageView()
    /// 도시 이름
    let nameLabel = UILabel()
    /// 날씨 상태
    let statusLabel = UILabel()
    /// 기온
    let temperatureLabel = UILabel()
    /// 위도
    let latitudeLabel = UILabel()
    /// 경도
    let longitudeLabel = UILabel()
    
    lazy var leftButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    }
    
    lazy var rightButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    }
    
    

    // MARK: - Methods
    func setupLayout() {
        self.backgroundColor = .systemBackground
        self.addSubviews([imgView, nameLabel, statusLabel, temperatureLabel, latitudeLabel, longitudeLabel])
        addSubviews([leftButton, rightButton])
        imgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(imgView.snp.height)
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(8)
            $0.bottom.equalTo(nameLabel.snp.top).offset(-8)
        }
        
        leftButton.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }

        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(20)
            $0.height.equalTo(21)
            $0.leading.equalTo(imgView.snp.leading)
            $0.trailing.equalTo(imgView.snp.trailing)
        }

        statusLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(nameLabel)
        }

        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(8)
            $0.leading.equalTo(statusLabel)
        }

        latitudeLabel.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(8)
            $0.leading.equalTo(temperatureLabel)
        }

        longitudeLabel.snp.makeConstraints {
            $0.top.equalTo(latitudeLabel.snp.bottom).offset(8)
            $0.leading.equalTo(latitudeLabel)
        }
    }

    // MARK: - model Dependency Injection
    /// 데이터 바인딩
    func setupDI<T>(observable: Observable<T>) {
        if let cityInfo = observable as? Observable<CityInfo> {
            cityInfo
                .observeOn(MainScheduler.instance)
                .bind(onNext: {[weak self] model in
                    guard let `self` = self else { return }
                    self.nameLabel.text = R.string.detail.cityName(model.name)
                    self.statusLabel.text = R.string.detail.status(model.status)
                    self.temperatureLabel.text = R.string.detail.temperature(model.temperature)
                    self.latitudeLabel.text = R.string.detail.lat(model.lat)
                    self.longitudeLabel.text = R.string.detail.lon(model.lon)
                    self.imgView.image = model.image
                }).disposed(by: disposeBag)
        } else {
            NSLog("Observable Type Error!!!(미구현): DetailView")
        }
    }
}
