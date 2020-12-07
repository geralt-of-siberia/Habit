
import UIKit

class HabitsViewController: UIViewController {
    let myStore = HabitsStore.shared
    let layout = UICollectionViewFlowLayout()
    let detailExample = HabitDetailsViewController()
    lazy var collectionView : UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.toLayout()
        collection.dataSource = self
        collection.delegate = self
        collection.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HabitCollectionViewCell.self))
        collection.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ProgressCollectionViewCell.self))
        collection.backgroundColor = .myGray
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLayout()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Сегодня"
        let item = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewHabit))
        item.tintColor = .myPurple
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setRightBarButton(item, animated: false)
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.tabBarController?.tabBar.tintColor = .myPurple
        }
    
    override func viewWillAppear(_ animated: Bool) {
        HabitsStore.shared.save()
        collectionView.reloadData()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    @objc private func addNewHabit() {

        let habitViewController = HabitViewController(newHabit: Habit(name: "", date: .distantPast, trackDates: [], color: .clear), detail: detailExample)
        let habitNav = UINavigationController(rootViewController: habitViewController)
        habitNav.modalPresentationStyle = .fullScreen
        habitViewController.addDetailLayout(false)
        navigationController?.present(habitNav, animated: true)
        HabitsStore.shared.save()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    
        if indexPath.section != 0 {
            
            detailExample.navigationController?.navigationBar.isHidden = false
            detailExample.title = HabitsStore.shared.habits[indexPath.row].name
            navigationController?.pushViewController(detailExample, animated: true)
        }
        
    }
    
    private func addLayout() {
    
        view.addSubview(collectionView)
        
        let constriants = [
        collectionView.topAnchor.constraint(equalTo: view.topAnchor),
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ]
        NSLayoutConstraint.activate(constriants)
    }
        
}

extension HabitsViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let progressSize = CGSize(width: collectionView.bounds.width, height: 60)
    let habitSize = CGSize(width: collectionView.bounds.width, height: 130)
    if indexPath.section == 0 {return progressSize}
    else { return habitSize}
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        18
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 22, left: 0, bottom: 0, right: 0)
    }
    
}

extension HabitsViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 { return 1}
        
        else {return HabitsStore.shared.habits.count}
        }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let habitCell : HabitCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HabitCollectionViewCell.self), for: indexPath) as! HabitCollectionViewCell
        let progressCell : ProgressCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgressCollectionViewCell.self), for: indexPath) as! ProgressCollectionViewCell

      
        
        progressCell.progressBar.setProgress(HabitsStore.shared.todayProgress, animated: true)
        progressCell.percentLabel.text = "\(Int(HabitsStore.shared.todayProgress*100))%"
        habitCell.reloadInputViews()
        habitCell.updateConstraintsIfNeeded()
        habitCell.collection = collectionView
        
        habitCell.reloadProgress = {
    
            UIView.animate(withDuration: 0.5) {
                collectionView.reloadData()
            }
            
        }
        
    if HabitsStore.shared.habits.isEmpty == false {
      if  HabitsStore.shared.habits[indexPath.row].isAlreadyTakenToday == true {
        habitCell.habitCircle.image = UIImage(systemName: "checkmark.circle.fill")
        habitCell.habitCircle.tintColor = HabitsStore.shared.habits[indexPath.row].color }
      else {habitCell.habitCircle.image = .none}}
//        
        if indexPath.section == 0 {return progressCell}

        else {
            
            habitCell.habit = HabitsStore.shared.habits[indexPath.row]
            return habitCell}
    }
    }
    

