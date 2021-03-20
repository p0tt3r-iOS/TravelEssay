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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                                style: .plain,
                                                                target: self,
                                                                action: nil)
        
        // Navigation Bar 타이틀 폰트, 색상 설정
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "NanumSquareR", size: 24)!
        ]
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 메인화면이 나타날 때, 네비게이션 바 숨김
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 메인화면이 사라지면, 네비게이션 바 띄움
        self.navigationController?.navigationBar.isHidden = false
    }
    
}
