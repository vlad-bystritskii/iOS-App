// AddNewHabitView.swift
// Created by Zlata Guseva on 13.10.2022.

import UIKit

class AddNewHabitView: UIView {
    private var nameInputView = TextFieldView(text: "Name", placeholder: "Name habit")
    private var reminderInputView = TextFieldView(text: "Reminder Note", placeholder: "Note")

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        addSubview(nameInputView)
        addSubview(reminderInputView)
    }

    private func makeConstraints() {
        nameInputView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(128)
        }

        reminderInputView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(nameInputView.snp.bottom).offset(32)
        }
    }
}
