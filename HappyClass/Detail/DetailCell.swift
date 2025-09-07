//
//  DetailCell.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import Then
import SnapKit

final class DetailCell: BaseCollectionViewCell {
    
    let imageView = UIImageView()
    
    override func prepareForReuse() {
        imageView.cancelDownload()
        imageView.image = nil
    }
}

extension DetailCell {
    
    override func configureHierarchy() {
            contentView.addSubview(imageView)
    }
    
    override func configureLayout() {
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
