// HomeViewController.swift
// FunnyPuny. Created by Zlata Guseva.

import JTAppleCalendar
import RealmSwift
import SwiftDate
import UIKit

// MARK: - HomeViewController

class HomeViewController: ViewController {
    private var homeView = HomeView()
    var habits: Results<Habit>?
    var currentHabits: Results<Habit>?
    var selectedDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Texts.home
        view = homeView
        setupTableView()
        setupData()
        setupCalendar()
        setupNotification()
        setupTargets()
    }

    @objc private func habitDidAdd() {
        homeView.tableView.reloadData()
    }

    fileprivate func setupCurrentHabits() {
        currentHabits = habits?.where {
            $0.frequency.contains(Day(rawValue: selectedDate.dateComponents.weekday ?? 1) ?? .sun)
        }
        homeView.tableView.reloadData()
    }

    private func setupData() {
        habits = realm.objects(Habit.self)
        setupCurrentHabits()
    }

    private func setupTableView() {
        homeView.tableView.dataSource = self
        homeView.tableView.delegate = self
    }

    private func setupCalendar() {
        homeView.calendarView.monthView.calendarDelegate = self
        homeView.calendarView.monthView.calendarDataSource = self
        homeView.calendarView.headerView.addHabitButton.addTarget(
            self,
            action: #selector(addButtonPressed),
            for: .touchUpInside
        )
        scrollToDate(Date(), animated: false)
    }

    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(habitDidAdd),
            name: .habitDidAdd,
            object: nil
        )
    }

    private func setupTargets() {
        let headerTap = UITapGestureRecognizer(target: self, action: #selector(headerDatePressed))
        homeView.calendarView.headerView.addGestureRecognizer(headerTap)
    }

    @objc
    private func headerDatePressed() {
        scrollToDate(Date())
    }

    @objc
    private func addButtonPressed() {
        let addHabitViewController = NavigationController(rootViewController: AddHabitViewController())
        if let sheet = addHabitViewController.sheetPresentationController {
            sheet.detents = [.large()]
        }
        present(addHabitViewController, animated: true)
    }

    private func scrollToDate(_ date: Date, animated: Bool = true) {
        homeView.calendarView.monthView.scrollToDate(
            date - 3.days,
            animateScroll: animated,
            extraAddedOffset: -4
        )
        homeView.calendarView.headerView.dateLabel.text = date.string(dateFormat: .formatMMMMd)
        selectedDate = date
        setupCurrentHabits()
    }
}

// MARK: UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath, withClass: HomeCell.self)
        do {
            try realm.write {
                let dateString = selectedDate.string(dateFormat: .formatyyMMdd)
                guard let habitId = (currentHabits?[indexPath.row].id) else {
                    return
                }

                if let history = realm.object(ofType: CompletedHabits.self, forPrimaryKey: dateString) {
                    if cell.isDone {
                        history.habits.remove(value: habitId)
                    } else {
                        history.habits.append(habitId)
                    }
                } else {
                    let history = CompletedHabits(date: dateString)
                    history.habits.append(habitId)
                    realm.add(history)
                }
            }
        } catch let error as NSError {
            print("Can't update habit, error: \(error)")
        }
        homeView.calendarView.monthView.reloadDates([selectedDate])
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        currentHabits?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: HomeCell.self)
        var viewModel = HomeCellViewModel(habitName: currentHabits?[indexPath.row].name ?? "", isDone: false)

        let date = selectedDate.string(dateFormat: .formatyyMMdd)
        let completedHabits = realm.object(ofType: CompletedHabits.self, forPrimaryKey: date)
        if
            let habitId = currentHabits?[indexPath.row].id,
            let completedHabits,
            completedHabits.habits.contains(habitId)
        {
            viewModel.isDone = true
            cell.configure(with: viewModel)
        } else {
            viewModel.isDone = false
            cell.configure(with: viewModel)
        }
        return cell
    }
}

// MARK: JTACMonthViewDelegate

extension HomeViewController: JTACMonthViewDelegate {
    func calendar(
        _ calendar: JTACMonthView,
        cellForItemAt date: Date,
        cellState: CellState,
        indexPath: IndexPath
    ) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withClass: CalendarHomeDateCell.self, indexPath: indexPath)
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }

    func calendar(
        _: JTACMonthView,
        willDisplay cell: JTACDayCell,
        forItemAt _: Date,
        cellState: CellState,
        indexPath _: IndexPath
    ) {
        configureCell(view: cell, cellState: cellState)
    }

    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? CalendarHomeDateCell else { return }
        cell.configure(with: .init(date: cellState.date))
    }

    func calendar(
        _: JTACMonthView,
        didSelectDate date: Date,
        cell _: JTACDayCell?,
        cellState _: CellState,
        indexPath _: IndexPath
    ) {
        scrollToDate(date)
    }
}

// MARK: JTACMonthViewDataSource

extension HomeViewController: JTACMonthViewDataSource {
    func configureCalendar(_: JTAppleCalendar.JTACMonthView) -> JTAppleCalendar.ConfigurationParameters {
        let parameters = ConfigurationParameters(
            startDate: Date() - 10.years,
            endDate: Date() + 10.years,
            numberOfRows: 1
        )
        return parameters
    }
}
