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
import RxSwift

final class MainCell: BaseTableViewCell {
    
    var disposeBag = DisposeBag()
    
    private let mainImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    let likeButton = UIButton().then {
        $0.setImage(.likeButton, for: .normal)
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    private let categoryView = CategoryLabelView()

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
        disposeBag = DisposeBag()
    }
    
}

extension MainCell {
    override func configureHierarchy() {
        
        [
            mainImageView,
            likeButton,
            nameLabel,
            categoryView,
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
            $0.trailing.equalTo(categoryView.snp.leading).offset(-4)
        }
        
        categoryView.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
            $0.width.equalTo(40)
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
        super.configureView()
        salePriceLabel.isHidden = true
        discountLabel.isHidden = true
    }
    
    func configure(with data: Course) {
        
        if let path = data.imageURL {
            mainImageView.setKFImage(path: path)
        } else if let path = data.imageURLS {
            mainImageView.setKFImage(path: path[0])
        }
        
        let likeImage: UIImage = data.isLiked ? .likeButtonFill : .likeButton
        likeButton.setImage(likeImage, for: .normal)
        
        nameLabel.text = data.title
        
        categoryView.label.text = Category(rawValue: data.category)?.name
        
        descriptionLabel.text = data.description
        
        if let price = data.price {
            if let sale = data.salePrice {
                let text = data.priceString
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
                priceLabel.text = data.priceString
            }
        } else {
            priceLabel.text = data.priceString
            priceLabel.textColor = .mainOrange
        }
    }
}
