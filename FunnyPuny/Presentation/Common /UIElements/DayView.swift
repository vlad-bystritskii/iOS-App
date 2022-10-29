// DayView.swift
// FunnyPuny. Created by Zlata Guseva.

import UIKit

class DayView: UIView {
    var day: Day
    var isSelected: Bool

    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = day.toString()
        label.textColor = isSelected ? .background : .foreground
        label.font = .regular17
        label.textAlignment = .center
        return label
    }()

    required init(_ day: Day, isSelected: Bool = false) {
        self.day = day
        self.isSelected = isSelected
        super.init(frame: .zero)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        addSubviews()
        layer.cornerRadius = 6
        setupStyle()
        makeConstraints()
        addTap()
    }

    private func addSubviews() {
        addSubview(dayLabel)
    }

    private func makeConstraints() {
        dayLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }

    private func setupStyle() {
        backgroundColor = isSelected ? .vividPink : .pinkLight
        dayLabel.textColor = isSelected ? .background : .foreground
    }

    private func addTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(daySelected))
        addGestureRecognizer(tap)
    }

    @objc
    func daySelected() {
        isSelected.toggle()
        setupStyle()
    }
}
