//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Богдан Киселев on 05.11.2020.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    private lazy var cellContent : UIView = {
        let content = UIView()
        content.backgroundColor = .white
        content.layer.cornerRadius = 8
        content.layer.masksToBounds = true
        content.backgroundColor = .white
        content.toLayout()
        return content
    }()
    
     lazy var progressBar : UIProgressView = {
       let bar = UIProgressView()
        bar.toLayout()
        bar.progressTintColor = .myPurple
        return bar
    }()
    
    private lazy var greetingLabel : UILabel = {
        let text = UILabel()
        text.toLayout()
        text.font = .systemFont(ofSize: 15, weight: .semibold)
        text.textColor = .systemGray3
        text.text = "Всё получится!"
        return text
    }()
    
    lazy var percentLabel : UILabel = {
        let text = UILabel()
        text.toLayout()
        text.textColor = .systemGray3
        text.font = .systemFont(ofSize: 15)
        text.text = "\(HabitsStore.shared.todayProgress*100)"
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    private func addLayout(){
    
        self.addSubview(cellContent)
        cellContent.addSubview(progressBar)
        cellContent.addSubview(greetingLabel)
        cellContent.addSubview(percentLabel)
    
        let constraints = [
            cellContent.topAnchor.constraint(equalTo: topAnchor),
            cellContent.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cellContent.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cellContent.heightAnchor.constraint(equalToConstant: 60),
            greetingLabel.topAnchor.constraint(equalTo: cellContent.topAnchor, constant: 10),
            greetingLabel.leadingAnchor.constraint(equalTo: cellContent.leadingAnchor, constant: 12),
            progressBar.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 10),
            progressBar.leadingAnchor.constraint(equalTo: cellContent.leadingAnchor, constant: 12),
            progressBar.trailingAnchor.constraint(equalTo: cellContent.trailingAnchor, constant: -12),
            progressBar.heightAnchor.constraint(equalToConstant: 7),
            percentLabel.topAnchor.constraint(equalTo: cellContent.topAnchor, constant: 10),
            percentLabel.trailingAnchor.constraint(equalTo: cellContent.trailingAnchor, constant: -12)
        
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
}
