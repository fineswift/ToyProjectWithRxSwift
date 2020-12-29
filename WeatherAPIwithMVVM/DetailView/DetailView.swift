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
    
    // MARK: - Properties
    let nextRelay = PublishRelay<Void>()
    let beforeRelay = PublishRelay<Void>()

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
    /// 다음 버튼
    lazy var nextButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.rx.tap.bind(to: nextRelay).disposed(by: disposeBag)
    }
    /// 이전 버튼
    lazy var beforeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.rx.tap.bind(to: beforeRelay).disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    func setupLayout() {
        self.backgroundColor = .systemBackground
        self.addSubviews([imgView, nameLabel, statusLabel, temperatureLabel, latitudeLabel, longitudeLabel])
        addSubviews([nextButton, beforeButton])
        
        imgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(imgView.snp.height)
            $0.top.equalToSafeAreaAuto(self).offset(8)
            $0.bottom.equalTo(nameLabel.snp.top).offset(-8)
        }
        
        nextButton.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        beforeButton.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
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
    @discardableResult
    func setupDI<T>(observable: Observable<T>) -> Self {
        if let cityInfo = observable as? Observable<CityInfo?> {
            cityInfo
                .compactMap { $0 }
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
        return self
    }
    
    /// 다음 버튼 tap
    @discardableResult
    func setupDI(nextModel: PublishRelay<Void>) -> Self {
        nextRelay.bind(to: nextModel).disposed(by: disposeBag)
        return self
    }
    
    /// 이전 버튼 tap
    @discardableResult
    func setupDI(beforeModel: PublishRelay<Void>) -> Self {
        beforeRelay.bind(to: beforeModel).disposed(by: disposeBag)
        return self
    }
}
