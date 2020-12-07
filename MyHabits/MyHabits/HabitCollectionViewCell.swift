//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Богдан Киселев on 05.11.2020.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    private lazy var circleTap = UITapGestureRecognizer(target: self, action: #selector(circleTapped))
    
    var habit: Habit? {
        didSet {
            guard let habit = habit else { return }
            habitName.text = habit.name
            habitName.textColor = habit.color
            habitTime.text = habit.dateString
            habitCount.text = "Подряд: \(habit.trackDates.count)."
            habitCircle.tintColor = habit.color
            habitCheck.tintColor = habit.color
            if habit.isAlreadyTakenToday {
                habitCircle.image = UIImage(systemName: "checkmark.circle.fill")
            } else { habitCircle.image = UIImage(systemName: "circle") }
        }
    }
    
    
    
    private lazy var habitContent : UIView = {
        let content = UIView()
        content.backgroundColor = .white
        content.layer.cornerRadius = 8
        content.layer.masksToBounds = true
        content.toLayout()
        return content
    }()
    
    lazy var habitName : UILabel = {
        let text = UILabel()
        text.font = .systemFont(ofSize: 17, weight: .semibold)
        text.numberOfLines = 2
        text.toLayout()
        return text
    }()

    private lazy var habitTime : UILabel = {
        let text = UILabel()
        text.font = .systemFont(ofSize: 12)
        text.textColor = .gray
        text.toLayout()
        return text
    }()
    
    lazy var habitCount : UILabel = {
        let text = UILabel()
        text.font = .systemFont(ofSize: 13, weight: .semibold)
        text.textColor = .darkGray
        text.toLayout()
        return text
    }()
    
    lazy var habitCircle : UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 18
        view.image = .add
        view.addGestureRecognizer(circleTap)
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleToFill
        view.toLayout()
        return view
    }()
    
    lazy var habitCheck : UIImageView = {
        let view = UIImageView()
        view.image = .checkmark
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        view.contentMode = .scaleToFill
        view.toLayout()
        return view
    }()
    
    lazy var collection : UICollectionView = {
       let coll = UICollectionView()
        return coll
    }()
    
    var reloadProgress : () -> Void = {}
    
    @objc func circleTapped () {

    for i in HabitsStore.shared.habits where i.isAlreadyTakenToday == false && i.name == habitName.text {

        HabitsStore.shared.track(i)
        HabitsStore.shared.save()
        UIView.animate(withDuration: 0.5, animations: {
            self.reloadProgress()
        })
        habitCircle.image = UIImage(systemName: "checkmark.circle.fill")
    habitCircle.tintColor = habitCheck.tintColor

        }}

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
 
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

private extension HabitCollectionViewCell {
    
    func setupLayout() {
        
        contentView.addSubview(habitContent)
        habitContent.addSubview(habitName)
        habitContent.addSubview(habitTime)
        habitContent.addSubview(habitCount)
        habitContent.addSubview(habitCircle)
        let constraints = [
            habitContent.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            habitContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            habitContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            habitContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            habitName.topAnchor.constraint(equalTo: habitContent.topAnchor, constant: 20),
            habitName.leadingAnchor.constraint(equalTo: habitContent.leadingAnchor, constant: 20),
            habitName.trailingAnchor.constraint(equalTo: habitCircle.leadingAnchor, constant: -26),
            habitTime.topAnchor.constraint(equalTo: habitName.bottomAnchor, constant: 4),
            habitTime.leadingAnchor.constraint(equalTo: habitContent.leadingAnchor, constant: 20),
            habitCount.bottomAnchor.constraint(equalTo: habitContent.bottomAnchor, constant: -20),
            habitCount.leadingAnchor.constraint(equalTo: habitContent.leadingAnchor, constant: 20),
            habitCircle.centerYAnchor.constraint(equalTo: habitContent.centerYAnchor),
            habitCircle.trailingAnchor.constraint(equalTo: habitContent.trailingAnchor, constant: -26),
            habitCircle.widthAnchor.constraint(equalToConstant: 36),
            habitCircle.heightAnchor.constraint(equalToConstant: 36),

        ]
    
        NSLayoutConstraint.activate(constraints)
    
    }
    
}
