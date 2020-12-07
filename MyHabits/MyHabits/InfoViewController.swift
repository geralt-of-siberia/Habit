//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Богдан Киселев on 29.10.2020.
//

import UIKit

class InfoViewController: UIViewController {

    
    private lazy var InfoScroll : UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var infoTitle : UILabel = {
        let text = UILabel()
        text.text = "Привычка за 21 день"
        text.font = .boldSystemFont(ofSize: 22)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var infoText : UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:\n\n1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага.\n\n2. Выдержать 2 дня в прежнем состоянии самоконтроля.\n\n3. Отметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче, с чем еще предстоит серьезно бороться.\n\n4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.\n\n5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой.\n\n6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся.\n\n\nИсточник: psychbook.ru"
        text.numberOfLines = 0
        text.isUserInteractionEnabled = true
        text.sizeToFit()
        text.font = .systemFont(ofSize: 20)
        
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Информация"

        addLayout()
    }

    
    
    private func addLayout(){
        
        view.addSubview(InfoScroll)
        InfoScroll.addSubview(infoTitle)
        InfoScroll.addSubview(infoText)
        
        
        let constraints = [
            InfoScroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            InfoScroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            InfoScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            InfoScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoTitle.topAnchor.constraint(equalTo: InfoScroll.topAnchor, constant: 22),
            infoTitle.leadingAnchor.constraint(equalTo: InfoScroll.leadingAnchor, constant: 16),
            infoTitle.trailingAnchor.constraint(equalTo: InfoScroll.trailingAnchor, constant: -16),
            infoTitle.centerXAnchor.constraint(equalTo: InfoScroll.centerXAnchor),
            infoText.topAnchor.constraint(equalTo: infoTitle.bottomAnchor,constant: 16),
            infoText.bottomAnchor.constraint(equalTo: InfoScroll.bottomAnchor),
            infoText.leadingAnchor.constraint(equalTo: InfoScroll.leadingAnchor, constant: 16),
            infoText.trailingAnchor.constraint(equalTo: InfoScroll.trailingAnchor, constant: -16)

        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    
}

