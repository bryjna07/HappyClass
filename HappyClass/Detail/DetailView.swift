//
//  DetailView.swift
//  HappyClass
//
//  Created by YoungJin on 9/5/25.
//

import UIKit
import Then
import SnapKit

final class DetailView: BaseView {
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 240)
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.register(DetailCell.self, forCellWithReuseIdentifier: DetailCell.identifier)
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
    }
    
    private let profileImageView = UIImageView()
    
    private let nicknameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }
    
    private let containerView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.disSelected.cgColor
        $0.layer.cornerRadius = 16
    }
    
    private let placeInfoLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .mainGray
        $0.text = "장소"
    }
    
    private let placeImageView = UIImageView().then {
        $0.image = UIImage(systemName: "location.fill")
        $0.tintColor = .mainOrange
        $0.contentMode = .scaleAspectFit
    }
    
    private let placeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .mainGray
    }
    
    private let timeInfoLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .mainGray
        $0.text = "시간"
    }

    private let timeImageView = UIImageView().then {
        $0.image = UIImage(systemName: "clock.fill")
        $0.tintColor = .mainOrange
        $0.contentMode = .scaleAspectFit
    }
    
    private let timeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .mainGray
    }
    
    private let peopleInfoLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .mainGray
        $0.text = "인원"
    }
    
    private let peopleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .mainGray
    }

    private let peopleImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.fill")
        $0.tintColor = .mainOrange
        $0.contentMode = .scaleAspectFit
    }

    private let infoLabel = UILabel().then {
        $0.text = "클래스 소개"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .navy
    }

    private let descriptionTextView = UITextView().then {
        $0.font = .systemFont(ofSize: 14)
        $0.isEditable = false
        $0.showsVerticalScrollIndicator = false
    }

    private let bottomLineView = UIView().then {
        $0.backgroundColor = .disSelected
    }
    
    private let likeButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart")
        config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.baseForegroundColor = .mainGray
        $0.configuration = config
    }
    
    private let commentButton = UIButton().then {
        $0.setTitle("댓글보기", for: .normal)
        $0.backgroundColor = .disSelected
    }
    
}

extension DetailView {
    
    override func configureHierarchy() {
        
        profileImageView.backgroundColor = .navy
        
        [
            placeInfoLabel, placeImageView, placeLabel,
            timeInfoLabel, timeImageView, timeLabel,
            peopleInfoLabel, peopleImageView, peopleLabel
        ].forEach {
            containerView.addSubview($0)
        }
        
        [
            collectionView,
            profileImageView, nicknameLabel,
            containerView,
            infoLabel,
            descriptionTextView,
            bottomLineView,
            likeButton, commentButton
        ].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
     
        collectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(240)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(44)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        placeInfoLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        placeImageView.snp.makeConstraints {
            $0.centerY.equalTo(placeInfoLabel)
            $0.leading.equalTo(placeInfoLabel.snp.trailing).offset(12)
            $0.size.equalTo(16)
        }
        
        placeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(placeImageView.snp.trailing).offset(8)
        }
        
        timeInfoLabel.snp.makeConstraints {
            $0.top.equalTo(placeInfoLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        timeImageView.snp.makeConstraints {
            $0.centerY.equalTo(timeInfoLabel)
            $0.leading.equalTo(timeInfoLabel.snp.trailing).offset(12)
            $0.size.equalTo(16)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(placeInfoLabel.snp.bottom).offset(16)
            $0.leading.equalTo(timeImageView.snp.trailing).offset(8)
        }
        
        peopleInfoLabel.snp.makeConstraints {
            $0.top.equalTo(timeInfoLabel.snp.bottom).offset(16)
            $0.leading.bottom.equalToSuperview().inset(16)
        }
        
        peopleImageView.snp.makeConstraints {
            $0.centerY.equalTo(peopleInfoLabel)
            $0.leading.equalTo(peopleInfoLabel.snp.trailing).offset(12)
            $0.size.equalTo(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        peopleLabel.snp.makeConstraints {
            $0.top.equalTo(timeInfoLabel.snp.bottom).offset(16)
            $0.leading.equalTo(peopleImageView.snp.trailing).offset(8)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        bottomLineView.snp.makeConstraints {
            $0.top.equalTo(descriptionTextView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.height.equalTo(0.5)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(bottomLineView.snp.bottom).offset(16)
            $0.leading.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            $0.size.equalTo(44)
        }
        
        commentButton.snp.makeConstraints {
            $0.top.equalTo(bottomLineView.snp.bottom).offset(16)
            $0.leading.equalTo(likeButton.snp.trailing).offset(16)
            $0.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(44)
        }
    }
    
    override func configureView() {
        super.configureView()
        profileImageView.layer.cornerRadius = 22
        profileImageView.clipsToBounds = true
        
        commentButton.layer.cornerRadius = 8
        commentButton.clipsToBounds = true
    }
    
    func configure(with data: Course) {
        
        if let path = data.creator.profileImage {
            profileImageView.setKFImage(path: path)
        }
        
        nicknameLabel.text = data.creator.nick
 
        placeLabel.text = data.location
        
        if let date = data.date {
            timeLabel.text = DateFormatManager.shared.detailDisplayFormat(dateString: date)
        } else {
            timeLabel.text = "미정"
        }
        
        peopleLabel.text = data.capacityString
 
        let text = data.description
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 8
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraph
        ]
        
        descriptionTextView.attributedText = NSAttributedString(string: text, attributes: attributes)
        
        let likeImage = data.isLiked ? "heart.fill" : "heart"
        let color: UIColor = data.isLiked ? .mainOrange : .disSelected
        likeButton.setImage(UIImage(systemName: likeImage), for: .normal)
        likeButton.tintColor = color
    }
    
}
