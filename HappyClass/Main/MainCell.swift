//
//  MainCell.swift
//  HappyClass
//
//  Created by YoungJin on 9/6/25.
//

import UIKit
import Then
import SnapKit
import Kingfisher

final class MainCell: BaseTableViewCell {
    
    private let mainImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let likeButton = UIButton().then {
        $0.setImage(.likeButton, for: .normal)
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    private let categoryLabel = CategoryLabel()

    private let descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .mainGray
        $0.numberOfLines = 1
    }
    
    private let priceLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    private let salePriceLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    private let discountLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .mainOrange
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.cancelDownload()
        mainImageView.image = nil
        priceLabel.attributedText = nil
        salePriceLabel.isHidden = true
        discountLabel.isHidden = true
    }
    
}

extension MainCell {
    override func configureHierarchy() {
        [
            mainImageView,
            likeButton,
            nameLabel,
            categoryLabel,
            descriptionLabel,
            priceLabel, salePriceLabel, discountLabel
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        mainImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(mainImageView.snp.width).multipliedBy(9.0/16.0)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(32)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(16)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(4)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        salePriceLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.leading.equalTo(priceLabel.snp.trailing).offset(8)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        discountLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.leading.equalTo(salePriceLabel.snp.trailing).offset(8)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    
    override func configureView() {
        salePriceLabel.isHidden = true
        discountLabel.isHidden = true
    }
    
    func configure(with data: Courses) {
        
        mainImageView.setKFImage(path: data.imageURL)
        
        let likeImage: UIImage = data.isLiked ? .likeButtonFill : .likeButton
        likeButton.setImage(likeImage, for: .normal)
        
        nameLabel.text = data.title
        
        categoryLabel.text = Category(rawValue: data.category)?.name
        
        descriptionLabel.text = data.description
        
        if let price = data.price {
            if let sale = data.salePrice {
                let text = "\(price.formatted())원"
                let attribute = NSMutableAttributedString(string: text)
                attribute.addAttributes([
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.mainGray
                ], range: NSRange(location: 0, length: attribute.length))
                priceLabel.attributedText = attribute
                
                salePriceLabel.isHidden = false
                salePriceLabel.text = "\(sale.formatted())원"
                
                discountLabel.isHidden = false
                discountLabel.text = data.dicountPercent
                
            } else {
                priceLabel.text = "\(price.formatted())원"
            }
        } else {
            priceLabel.text = "무료"
            priceLabel.textColor = .mainOrange
        }
    }
}
