//
//  MainCell.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/18.
//

import UIKit

class MainCell: UITableViewCell {
    
    // MARK: - Objects
    /// 날씨 이미지
    let imgView = UIImageView()
    /// 도시 이름
    let nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17)
    }
    /// 현재 기온
    let temperaturesLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15)
    }

    func setupLayout() {
        accessoryType = .disclosureIndicator
        addSubviews([imgView, nameLabel, temperaturesLabel])
        imgView.snp.makeConstraints {
            $0.width.equalTo(imgView.snp.height).multipliedBy(1)
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(imgView.snp.centerY)
            $0.leading.equalTo(imgView.snp.trailing).offset(5)
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        temperaturesLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.bottom.equalToSuperview().offset(-5)
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        /// 셀 선택 상태 초기화
        if isSelected {
            isSelected = false
        }
    }
    /*
    func mapping(text: String?, temp: String?, image: UIImage?) {
        self.nameLabel.text = text
        self.temperaturesLabel.text = temp
        self.imgView.image = image
    }
    */
    func mapping<T>(data: T) {
        if let cityInfo = data as? CityInfo {
            nameLabel.text = cityInfo.name
            temperaturesLabel.text = cityInfo.temperature
            imgView.image = cityInfo.image
        } else {
            NSLog("MainView mapping Error!!!(미구현)")
        }
    }
}
