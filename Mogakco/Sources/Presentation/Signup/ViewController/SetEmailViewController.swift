//
//  SetEmailViewController.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/15.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SetEmailViewController: ViewController {
    
    private let viewModel: SetEmailViewModel
    
    enum Constant {
        static let navigationTitle = "회원가입"
        static let title = "이메일 입력"
        static let subtitle = "회원가입을 위한 이메일을 입력해주세요"
        static let placeholder = "이메일을 입력해주세요"
        static let validMessage = "유효한 이메일입니다."
        static let invalidMessage = "올바르지 않은 이메일 형식입니다."
        static let buttonTitle = "다음"
    }
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.text = Constant.title
        $0.font = UIFont.mogakcoFont.title1Bold
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
    }
    
    private let subtitleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.text = Constant.subtitle
        $0.font = UIFont(name: SFPro.regular.rawValue, size: 16)
        $0.textColor = UIColor.mogakcoColor.typographySecondary
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private let textField = MessageTextField().then {
        $0.placeholder = Constant.placeholder
    }
    
    private let button = ValidationButton().then {
        $0.titleLabel?.font = UIFont.mogakcoFont.mediumBold
        $0.setTitle(Constant.buttonTitle, for: .normal)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.isEnabled = false
    }
    
    // MARK: - Inits
    
    init(viewModel: SetEmailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        layout()
        keyboardEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = Constant.navigationTitle
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    
    override func bind() {
        
        let input = SetEmailViewModel.Input(
            email: textField.rx.text.orEmpty.asObservable(),
            nextButtonTapped: button.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.textFieldState
            .subscribe { [weak self] in
                let state: TextField.Validation = $0 ? .valid : .invalid
                let message = $0 ? Constant.validMessage : Constant.invalidMessage
                self?.textField.validation = state
                self?.textField.message = message
            }
            .disposed(by: disposeBag)
        
        output.nextButtonEnabled
            .subscribe { [weak self] enabled in
                self?.button.isEnabled = enabled
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Layout
    
    override func layout() {
        layoutStackView()
        layoutTextField()
        layoutButton()
    }
    
    private func layoutStackView() {
        [titleLabel, subtitleLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    
    private func layoutTextField() {
        view.addSubview(textField)
        textField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(stackView.snp.bottom).offset(16)
        }
    }
    
    private func layoutButton() {
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(52)
        }
    }
    
    // MARK: - Keyboard
    
    func keyboardEvent() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.button.snp.remakeConstraints {
                $0.height.equalTo(52)
                $0.left.right.equalToSuperview().inset(16)
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-keyboardFrame.height)
            }
            UIView.animate(withDuration: 1) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.button.snp.remakeConstraints {
            $0.height.equalTo(52)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
        }
        UIView.animate(withDuration: 1) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
