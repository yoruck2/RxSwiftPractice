//
//  RxValidationViewController.swift
//  RxSwiftPractice
//
//  Created by dopamint on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class RxValidationViewController: RxBaseViewController {
    
    private let minimalUsernameLength = 5
    private let minimalPasswordLength = 5
    
    let usernameLabel = UILabel().then {
        $0.text = "Username"
    }
    let passowrdLabel = UILabel().then {
        $0.text = "Password"
    }
    
    var usernameOutlet = UITextField().then {
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor(named: "gray")?.cgColor
    }
    var usernameValidOutlet = UILabel().then {
        $0.textColor = .red
    }
    
    var passwordOutlet = UITextField().then {
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor(named: "gray")?.cgColor
    }
    var passwordValidOutlet = UILabel().then {
        $0.textColor = .red
    }
    
    var doSomethingOutlet = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameValidOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        let usernameValid = usernameOutlet.rx.text.orEmpty
            .map { $0.count >= self.minimalUsernameLength }
            .share(replay: 1) // without this map would be executed once for each binding, rx is stateless by default
        
        let passwordValid = passwordOutlet.rx.text.orEmpty
            .map { $0.count >= self.minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        
        usernameValid
            .bind(to: passwordOutlet.rx.isEnabled)
            .disposed(by: disposeBag)
        
        usernameValid
            .bind(to: usernameValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: passwordValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)
        
        everythingValid
            .bind(to: doSomethingOutlet.rx.isEnabled)
            .disposed(by: disposeBag)
        
        doSomethingOutlet.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.showAlert() })
            .disposed(by: disposeBag)
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func configureHierarchy() {
        view.addSubview(usernameLabel)
        view.addSubview(usernameOutlet)
        view.addSubview(usernameValidOutlet)
        view.addSubview(passowrdLabel)
        view.addSubview(passwordOutlet)
        view.addSubview(passwordValidOutlet)
        view.addSubview(doSomethingOutlet)
    }
    override func configureLayout() {
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        usernameOutlet.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
        }
        usernameValidOutlet.snp.makeConstraints { make in
            make.top.equalTo(usernameOutlet.snp.bottom).offset(10)
            make.leading.equalTo(usernameOutlet)
        }
        
        passowrdLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameValidOutlet.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        passwordOutlet.snp.makeConstraints { make in
            make.top.equalTo(passowrdLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
        }
        passwordValidOutlet.snp.makeConstraints { make in
            make.top.equalTo(passwordOutlet.snp.bottom).offset(10)
            make.leading.equalTo(passwordOutlet)
        }
        
        doSomethingOutlet.snp.makeConstraints { make in
            make.top.equalTo(passwordValidOutlet.snp.bottom).offset(20)
            make.width.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
    }
}

