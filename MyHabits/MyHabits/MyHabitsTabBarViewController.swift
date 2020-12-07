//
//  MyHabitsTabBarViewController.swift
//  MyHabits
//
//  Created by Богдан Киселев on 29.10.2020.
//

import UIKit

class MyHabitsTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let habitsVC = HabitsViewController()
        let infoVC = InfoViewController()
        let hab = UINavigationController(rootViewController: habitsVC)
        hab.tabBarItem.title = "Привычки"
        hab.tabBarItem.image = #imageLiteral(resourceName: "habits_tab_icon")
        let nav = UINavigationController(rootViewController: infoVC)
        nav.tabBarItem.title = "Информация"
        nav.tabBarItem.image = UIImage(systemName: "info.circle.fill")
        self.viewControllers = [hab,nav]


    }
    

  
}

