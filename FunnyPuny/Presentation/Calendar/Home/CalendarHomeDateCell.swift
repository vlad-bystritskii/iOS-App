// CalendarHomeDateCell.swift
// FunnyPuny. Created by Zlata Guseva.

import JTAppleCalendar
import SnapKit
import UIKit

class CalendarHomeDateCell: JTACDayCell {
    var dayOfWeekLabel: UILabel = {
        let label = UILabel()
        label.textColor = .foreground
        label.font = .regular14
        label.backgroundColor = .background
        label.textAlignment = .center
        label.layer.cornerRadius = 9
        label.clipsToBounds = true
        return label
    }()

    var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .foreground
        label.font = .regular12
        label.backgroundColor = .background
        label.layer.borderColor = UIColor.greyLight?.cgColor
        label.layer.borderWidth = 1
        label.textAlignment = .center
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        return label
    }()

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
        addSubview(dayOfWeekLabel)
        addSubview(dateLabel)
    }

    private func makeConstraints() {
        dayOfWeekLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(18)
        }

        dateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(40)
        }
    }
}