//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Богдан Киселев on 29.10.2020.
//

import UIKit

class HabitViewController: UIViewController {
    
    
    private lazy var dateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        return format
    }()
       

    private lazy var pickerGesture = UITapGestureRecognizer(target: self, action: #selector(pickerTapped))
    
    private lazy var colorPicker : UIColorPickerViewController = {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        return picker
    }()
    
    var habit : Habit?
    var detail : HabitDetailsViewController?
    var detail2 : HabitDetailsViewController?
    
    private lazy var contentView : UIView = {
        let content = UIView()
        content.toLayout()
        return content
    }()
    
    private lazy var nameText : UILabel = {
        let text = UILabel()
        text.text = "Название"
        text.font = .boldSystemFont(ofSize: 18)
        text.toLayout()
        return text
    }()
    
    lazy var nameTextField : UITextField = {
        let text = UITextField()
        text.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        text.clearsOnBeginEditing = true
        text.clearsOnInsertion = true
        text.toLayout()
        return text
    }()
    
    private lazy var colorText : UILabel = {
        let text = UILabel()
        text.text = "Цвет"
        text.font = .boldSystemFont(ofSize: 18)
        text.toLayout()
        return text
    }()
    
    lazy var colorCircle : UIView = {
        let circle = UIView()
        circle.backgroundColor = .myPurple
        circle.layer.cornerRadius = 15
        circle.addGestureRecognizer(pickerGesture)
        circle.toLayout()
        return circle
    }()
    
    private lazy var timeText : UILabel = {
        let text = UILabel()
        text.toLayout()
        text.text = "Время"
        text.font = .boldSystemFont(ofSize: 18)

        return text
    }()
    
    lazy var selectedTime : UILabel = {
        let text = UILabel()
        let initialDate: String = dateFormatter.string(from: timePicker.date)
        text.text = initialDate
        text.textColor = .myPurple
        text.toLayout()
        return text
    }()
    
    private lazy var timeSchedule : UILabel = {
        let text = UILabel()
        text.text = "Каждый день в "
        text.toLayout()
        return text
    }()
    
    lazy var timePicker : UIDatePicker = {
        let myTime = UIDatePicker()
        myTime.datePickerMode = .time
        myTime.preferredDatePickerStyle = .wheels
        myTime.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        myTime.toLayout()
        return myTime
    }()
    
    private lazy var deleteButton : UIButton = {
        let button = UIButton()
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.toLayout()
        button.addTarget(self, action: #selector(deleteButtonPushed), for: .touchUpInside)
        return button
    }()
    
    
    let addHabitButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(habitSaved))

    init(newHabit: Habit, detail: HabitDetailsViewController ) {
        super.init(nibName: nil, bundle: nil)
        self.habit = newHabit
        self.detail = detail
     }
    
    init(oldHabit: Habit, detail: HabitDetailsViewController) {
        super.init(nibName: nil, bundle: nil)
        self.habit = oldHabit
        self.nameTextField.text = oldHabit.name
        self.detail2 = detail
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isUserInteractionEnabled = true
        self.navigationItem.title = "Создать"
        self.navigationItem.rightBarButtonItem = addHabitButton
       
        addLayout()
       
        addHabitButton.tintColor = .myPurple
    }
    

    @objc func deleteButtonPushed() {
        
        let alertController = UIAlertController(title: "Удалить привычку \(nameTextField.text ?? "") ?", message: "Удаление невозможно будет отменить", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in
        }
        let deleteAction = UIAlertAction(title: "Удалить", style: .default) { _ in
            
            for (n,i) in HabitsStore.shared.habits.enumerated() where i.name == self.nameTextField.text {
                HabitsStore.shared.habits.remove(at: n)
                self.dismiss(animated: true, completion: {
                    self.detail2?.navigationController?.popViewController(animated: true)
                })
                
                HabitsStore.shared.save()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
     
        
        
    }
    
   @objc func datePickerValueChanged(_ sender: UIDatePicker){
           
            let selectedDate: String = dateFormatter.string(from: sender.date)
            
            selectedTime.text = selectedDate
            print("text is \(selectedTime.text ?? "666")")
            print("Selected value \(selectedDate)")
        }
    
    @objc func pickerTapped() {
        present(colorPicker, animated: true, completion: nil)
    }
    
    @objc func habitCanceled() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func habitSaved () {
        
        let alertController = UIAlertController(title: "Такая привычка уже есть", message: "Пожалуйста, выберете другое название", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("OK")
        }
        alertController.addAction(cancelAction)
        let newHabit = Habit(name: nameTextField.text ?? "",
                             date: timePicker.date,
                             color: colorCircle.backgroundColor ?? colorPicker.selectedColor )
        let store = HabitsStore.shared
        
        for i in store.habits {
            guard i.name != newHabit.name else {return self.present(alertController, animated: true, completion: nil) }
        }
        store.habits.append(newHabit)
        HabitsStore.shared.save()
        self.dismiss(animated: true, completion: nil)}
    
    @objc func saveChanges() {

        for i in HabitsStore.shared.habits where i.name == habit?.name  {
            
            i.name = nameTextField.text ?? "Test"
            i.color = colorCircle.backgroundColor ?? .clear
            i.date = timePicker.date
            
        }
        
        HabitsStore.shared.save()
        detail2?.title = nameTextField.text
        detail?.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func addLayout() {
        
        view.addSubview(contentView)
        contentView.addSubview(nameText)
        contentView.addSubview(nameTextField)
        contentView.addSubview(colorText)
        contentView.addSubview(colorCircle)
        contentView.addSubview(timeText)
        contentView.addSubview(timeSchedule)
        contentView.addSubview(timePicker)
        contentView.addSubview(selectedTime)
        
        let constraints = [
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            nameText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameTextField.topAnchor.constraint(equalTo: nameText.bottomAnchor, constant: 7),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorText.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            colorText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorCircle.topAnchor.constraint(equalTo: colorText.bottomAnchor, constant: 7),
            colorCircle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorCircle.widthAnchor.constraint(equalToConstant: 30),
            colorCircle.heightAnchor.constraint(equalToConstant: 30),
            timeText.topAnchor.constraint(equalTo: colorCircle.bottomAnchor, constant: 15),
            timeText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timeText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            timeSchedule.topAnchor.constraint(equalTo: timeText.bottomAnchor, constant: 7),
            timeSchedule.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectedTime.leadingAnchor.constraint(equalTo: timeSchedule.trailingAnchor, constant: 5),
            selectedTime.centerYAnchor.constraint(equalTo: timeSchedule.centerYAnchor),
            timePicker.topAnchor.constraint(equalTo: timeSchedule.bottomAnchor, constant: 15),
            timePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func addDetailLayout(_ active: Bool) {
        let detailsConstraint = [
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        if active == true {
            view.addSubview(deleteButton)
            NSLayoutConstraint.activate(detailsConstraint)
       
            let rightButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveChanges))
            let cancelButton = UIBarButtonItem(title: "Отмена", style: .done, target: self, action: #selector(habitCanceled))
            self.navigationItem.rightBarButtonItem = rightButton
            self.navigationItem.leftBarButtonItem = cancelButton
            self.navigationItem.title = "Создать"
            cancelButton.tintColor = .myPurple
            rightButton.tintColor = .myPurple
        }
        else {
            let rightButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(habitSaved))
            let cancelButton = UIBarButtonItem(title: "Отмена", style: .done, target: self, action: #selector(habitCanceled))
            self.navigationItem.rightBarButtonItem = rightButton
            self.navigationItem.leftBarButtonItem = cancelButton
            cancelButton.tintColor = .myPurple
            rightButton.tintColor = .myPurple
            deleteButton.removeFromSuperview()
            NSLayoutConstraint.deactivate(detailsConstraint)}
    }
}

extension HabitViewController : UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorCircle.backgroundColor = colorPicker.selectedColor
    }
}

extension UIView {
    func toLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIColor {
static let myPurple = #colorLiteral(red: 0.631372549, green: 0.0862745098, blue: 0.8, alpha: 1)
static let myGray = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
}

