// HomeView.swift
// Created by Zlata Guseva on 12.10.2022.

import JTAppleCalendar
import SnapKit
import UIKit

class HomeView: UIView {
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .background
        tableView.register(cellWithClass: HomeCell.self)
        tableView.rowHeight = 86
        tableView.separatorStyle = .none
        return tableView
    }()

    var calendarView: CalendarView = {
        let view = CalendarView()
        return view
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
        addSubview(tableView)
        addSubview(calendarView)
    }

    private func makeConstraints() {
        calendarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(160)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
        }
    }
}
