//
//  CommentListCell.swift
//  HappyClass
//
//  Created by YoungJin on 9/6/25.
//

import UIKit
import Then
import SnapKit
import Kingfisher
import RxSwift

final class CommentListCell: BaseTableViewCell {
    
    var disposeBag = DisposeBag()

    private let profileImageView = UIImageView()
    
    private let nicknameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textColor = .navy
    }
    
    private let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .mainGray
    }
    
    let editButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "ellipsis")
        config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.baseForegroundColor = .navy
        $0.configuration = config
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.cancelDownload()
        profileImageView.image = nil
        editButton.isHidden = true
        disposeBag = DisposeBag()
    }
    
}

extension CommentListCell {
    override func configureHierarchy() {
        [
            profileImageView,
            nicknameLabel,
            dateLabel,
            editButton,
            descriptionLabel
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.size.equalTo(36)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top).offset(2)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(16)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.bottom.trailing.equalToSuperview().inset(16)
        }
    }
    
    override func configureView() {
        super.configureView()
        profileImageView.layer.cornerRadius = 18
        profileImageView.clipsToBounds = true
        editButton.isHidden = true
    }
    
    func configure(with data: Comment) {
        
        if let path = data.creator.profileImage {
            profileImageView.setKFImage(path: path)
        } else {
            profileImageView.image = UIImage(systemName: "person.fill")
        }
        
        nicknameLabel.text = data.creator.nick
        dateLabel.text = DateFormatManager.shared.commentDisplayFormat(dateString: data.createdAt)
        descriptionLabel.text = data.content
        
        if data.creator.userId == UserDefaultsManager.shared.id {
            editButton.isHidden = false
        }
    }
}
