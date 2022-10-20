// HomeViewController.swift
// Created by Zlata Guseva on 12.10.2022.

import JTAppleCalendar
import RealmSwift
import SwiftDate
import UIKit

class HomeViewController: ViewController {
    private var homeView = HomeView()
    var habits: Results<Habit>?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Texts.home
        view = homeView
        setupTableView()
        setupData()
        setupCalendar()
        setupNotification()
    }

    @objc private func habitDidAdd() {
        homeView.tableView.reloadData()
    }

    private func setupData() {
        habits = realm.objects(Habit.self)
        homeView.tableView.reloadData()
    }

    private func setupTableView() {
        homeView.tableView.dataSource = self
    }

    private func setupCalendar() {
        homeView.calendarView.calendarDelegate = self
        homeView.calendarView.calendarDataSource = self
    }

    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(habitDidAdd),
            name: .habitDidAdd,
            object: nil
        )
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        habits?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: HomeCell.self)
        cell.label.text = habits?[indexPath.row].name ?? ""
        return cell
    }
}

extension HomeViewController: JTACMonthViewDelegate, JTACMonthViewDataSource {
    func configureCalendar(_: JTAppleCalendar.JTACMonthView) -> JTAppleCalendar.ConfigurationParameters {
        let parameters = ConfigurationParameters(
            startDate: Date() - 10.years,
            endDate: Date() + 10.years,
            numberOfRows: 1
        )
        return parameters
    }

    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? CalendarDateCell else { return }
        cell.dateCell.text = cellState.text
    }

    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        // swiftlint:disable all
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarDateCell", for: indexPath) as! CalendarDateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }

    func calendar(_: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt _: Date, cellState: CellState, indexPath _: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        // swiftlint:disable all
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "CalendarHeaderView", for: indexPath) as! CalendarHeaderView
        header.monthTitle.text = range.start.string(dateFormat: .formatdMMMMyyyy)
        return header
    }

    func calendarSizeForMonths(_: JTACMonthView?) -> MonthSize? {
        MonthSize(defaultSize: 50)
    }
}
