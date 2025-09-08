//
//  SearchCell.swift
//  HappyClass
//
//  Created by YoungJin on 9/6/25.
//

import UIKit
import Then
import SnapKit
import Kingfisher
import RxSwift

final class SearchCell: BaseTableViewCell {
    
    var disposeBag = DisposeBag()

    private let mainImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let categoryView = CategoryLabelView()
    
    private let nameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    let likeButton = UIButton()
    
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

extension SearchCell {
    override func configureHierarchy() {
        [
            mainImageView,
            likeButton,
            nameLabel,
            categoryView,
            priceLabel, salePriceLabel, discountLabel
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        mainImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(mainImageView.snp.height).multipliedBy(1.3/1.0)
        }
        
        likeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        categoryView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalTo(mainImageView.snp.trailing).offset(8)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom).offset(4)
            $0.leading.equalTo(mainImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
        }
      
        priceLabel.snp.makeConstraints {
            $0.bottom.equalTo(salePriceLabel.snp.top).offset(-4)
            $0.leading.equalTo(mainImageView.snp.trailing).offset(8)
        }
        
        salePriceLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.equalTo(mainImageView.snp.trailing).offset(8)
        }
        
        discountLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.equalTo(salePriceLabel.snp.trailing).offset(8)
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
