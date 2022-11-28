//
//  StudyRatingView.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift
import UIKit

class StudyRatingView: UIView {
    private let iconImageView = UIImageView()

    private let contentLabel = UILabel().then {
        $0.font = .mogakcoFont.smallBold
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.textAlignment = .left
    }

    private lazy var countLabel = UILabel().then {
        $0.font = .mogakcoFont.smallBold
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.textAlignment = .right
    }

    private let bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(studyRating: (String, Int)) {
        iconImageView.image = UIImage(named: studyRating.0)
        contentLabel.text = studyRating.0
        countLabel.text = "+\(studyRating.1)"
    }

    private func attribute() {
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
    }

    private func layout() {
        let stackView = makeEntireStackView()
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func makeEntireStackView() -> UIStackView {
        let arrangeSubviews = [iconImageView, contentLabel, countLabel]
        iconImageView.snp.makeConstraints {
            $0.width.equalTo(iconImageView.snp.height)
        }
        return UIStackView(arrangedSubviews: arrangeSubviews).then {
            $0.axis = .horizontal
            $0.spacing = 4.0
        }
    }
}
