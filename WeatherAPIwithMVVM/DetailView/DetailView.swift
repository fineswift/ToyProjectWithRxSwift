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
    /// 오른쪽 버튼 tap = true, 왼쪽 버튼 tap = false
    lazy var buttonTapAction = PublishRelay<Bool>()

    // MARK: - Objects
    lazy var containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    /// 날씨 상태 이미지
    lazy var imgView = UIImageView()
    /// 도시 이름
    lazy var nameLabel = UILabel()
    /// 날씨 상태
    lazy var statusLabel = UILabel()
    /// 기온
    lazy var temperatureLabel = UILabel()
    /// 위도
    lazy var latitudeLabel = UILabel()
    /// 경도
    lazy var longitudeLabel = UILabel()
    /// 다음 버튼
    lazy var nextButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.rx.tap.map { _ in true }.bind(to: buttonTapAction).disposed(by: disposeBag)
    }
    /// 이전 버튼
    lazy var beforeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.rx.tap.map { _ in false }.bind(to: buttonTapAction).disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    func setupLayout() {
        backgroundColor = .systemBackground
        containerView.addSubviews([imgView, nameLabel, statusLabel, temperatureLabel, latitudeLabel, longitudeLabel])
        self.addSubviews([nextButton, containerView, beforeButton])
        
        nextButton.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        beforeButton.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
        }
        
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSafeAreaAuto(self)
            $0.leading.equalTo(beforeButton.snp.trailing)
            $0.trailing.equalTo(nextButton.snp.leading)
        }
        
        imgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.trailing.equalToSuperview()
        }

        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
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
    
    /// 좌우 버튼 tap
    @discardableResult
    func setupDI(buttonAction: PublishRelay<Bool>) -> Self {
        buttonTapAction.bind(to: buttonAction).disposed(by: disposeBag)
        return self
    }
}
