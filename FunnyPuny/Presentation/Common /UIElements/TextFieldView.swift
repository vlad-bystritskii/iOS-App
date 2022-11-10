// TextFieldView.swift
// FunnyPuny. Created by Zlata Guseva.

import UIKit

class TextFieldView: UIView {
    var text: String
    var placeholder: String

    lazy var label: UILabel = {
        let label = UILabel()
        label.text = text
        label.textColor = .foreground
        label.font = .regular20
        return label
    }()

    lazy var textField: TextField = {
        let textField = TextField()
        textField.placeholder = placeholder
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.greyLight ?? .clear]
        )
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.mainGrey?.cgColor
        textField.layer.borderWidth = CGFloat(1)
        return textField
    }()

    required init(text: String, placeholder: String) {
        self.text = text
        self.placeholder = placeholder
        super.init(frame: .zero)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        setupStyle()
        addSubviews()
        makeConstraints()
    }

    private func setupStyle() {
        backgroundColor = .background
    }

    private func addSubviews() {
        addSubview(label)
        addSubview(textField)
    }

    private func makeConstraints() {
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(24)
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.height.equalTo(40)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
