//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Богдан Киселев on 06.11.2020.
//

import UIKit

class HabitDetailsViewController: UIViewController {

    var detailExample : HabitDetailsViewController?
    var habit : HabitViewController?
    
    
    private lazy var dateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        return format
    }()
    
    private lazy var dateFormatterDate: DateFormatter = {
            let format = DateFormatter()
            format.dateStyle = .medium
            format.timeStyle = .none
            format.doesRelativeDateFormatting = true
            format.locale = Locale(identifier: "ru")
            return format
          }()
    
    private lazy var activityLabel : UILabel = {
        let label = UILabel()
        label.text = "АКТИВНОСТЬ"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemGray
        label.backgroundColor = .myGray
        return label
    }()
    
    private lazy var tableView : UITableView = {
        let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let table = UITableView(frame: rect, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        table.toLayout()
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let rightItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(habitEdit))
        rightItem.tintColor = .myPurple
        navigationItem.leftBarButtonItem?.tintColor = .myPurple
        self.navigationController?.navigationBar.tintColor = .myPurple
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.rightBarButtonItem = rightItem
        navigationController?.navigationBar.prefersLargeTitles = false
        toLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func toLayout() {

        view.addSubview(tableView)
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    @objc private func habitEdit() {
       
        for i in HabitsStore.shared.habits where i.name == title {
            detailExample?.title = i.name
            let habit = HabitViewController(oldHabit: i, detail: self)
        let hab = UINavigationController(rootViewController: habit)
            habit.addDetailLayout(true)
                        habit.nameTextField.text = i.name
                        habit.colorCircle.backgroundColor = i.color
            habit.selectedTime.text = dateFormatter.string(from: i.date)
            habit.title = "Править"
            habit.timePicker.date = i.date
            habit.navigationController?.navigationBar.isHidden = false
            present(hab, animated: true, completion: nil)
     
        }
    }
}

extension HabitDetailsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = .myGray
        activityLabel.frame = .init(x: 20, y: 20, width: headerView.frame.width - 10, height: 30)
        headerView.addSubview(activityLabel)
                return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }

    
}

extension HabitDetailsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HabitsStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID : String = "cellID"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = dateFormatterDate.string(from:HabitsStore.shared.dates[indexPath.item])
        
        
        for i in HabitsStore.shared.habits where i.name == title {
            if HabitsStore.shared.habit(i, isTrackedIn: HabitsStore.shared.dates[indexPath.item]) == true {
                cell.accessoryType = .checkmark
                cell.tintColor = .myPurple
            } else {cell.accessoryType = .none}
        }
        return cell
    }
}
