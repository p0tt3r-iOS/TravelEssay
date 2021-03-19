//
//  ViewController.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/18.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Methods
    func setUI() {
        // Status Bar가 흰색으로 표시됨
        self.navigationController?.navigationBar.barStyle = .black

        // Navigation Bar가 투명색으로 표시됨
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        // Back Button을 제목없이 표시
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                        NSAttributedString.Key.font: UIFont(name: "NanumSquareR", size: 24)!]
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
}
