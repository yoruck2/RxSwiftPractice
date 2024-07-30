//
//  PlaygroundViewController.swift
//  RxSwiftPractice
//
//  Created by dopamint on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
class PlaygroundViewController: RxBaseViewController {
    let backView = UIView()
    
    let pickerView = UIPickerView()
    
    let tableView = UITableView()
    
    let mySwitch = UISwitch()
    let nameTextField = UITextField().then {
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    let emailTextField = UITextField().then {
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    let signLabel = UILabel().then {
        $0.textColor = .black
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    let signButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.backgroundColor = .green
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureView()
        
        configureLayout()
        setPickerView()
        setTableView()
        setSwitch()
        setSign()
    }
    override func configureView() {
        pickerView.backgroundColor = #colorLiteral(red: 0.8519359231, green: 0.8621533513, blue: 0.8619735241, alpha: 1)
        
    }
    func setPickerView() {
        let items = Observable.just([
            "영화",
            "애니메이션",
            "드라마",
            "기타"
        ])
        
        items
            .bind(to: pickerView.rx.itemTitles) { (row, element) in
                return element
                
            }
            .disposed(by: disposeBag)
        
        pickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .subscribe { value in
                print(value)
            }
            .disposed(by: disposeBag)
    }
    func setTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First",
            "Second",
            "Third"
        ])
        
        items
//            .take(1)
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                
                cell.textLabel?.text = "\(element) @ row \(row)"
                return cell
            }
            .disposed(by: disposeBag)
        
        // item
        tableView.rx.itemSelected
            .bind { value in
                print("\(value)가 선택되었어요.")
            }
            .disposed(by: disposeBag)
        
        //  model
        tableView.rx.modelSelected(String.self)
            .bind { value in
                print("\(value)가 선택되었어요.")
            }
            .disposed(by: disposeBag)
        
        // zip (한번에)
        Observable.zip(tableView.rx.itemSelected,
                       tableView.rx.modelSelected(String.self))
        .bind { value in
            print(value.0, value.1)
            
        }
        .disposed(by: disposeBag)
    }
    func setSwitch() {
        Observable.of(false)
            .bind(to: mySwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    func setSign() {
        Observable.combineLatest(nameTextField.rx.text.orEmpty,
                                 emailTextField.rx.text.orEmpty) { value1, value2 in
            return "name은 \(value1)이고, 이메일은 \(value2) 입니다."
        }
                                 .bind(to: signLabel.rx.text)
                                 .disposed(by: disposeBag)
        
        nameTextField.rx.text.orEmpty
            .map { $0.count < 4 }
            .bind(to: emailTextField.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .map { $0.count < 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap
            .subscribe({ _ in
                self.showAlert()
            })
            .disposed(by: disposeBag)
    }

    override func configureHierarchy() {
        view.addSubview(backView)
        view.addSubview(pickerView)
        view.addSubview(tableView)
        view.addSubview(mySwitch)
        backView.addSubview(nameTextField)
        backView.addSubview(emailTextField)
        backView.addSubview(signLabel)
        backView.addSubview(signButton)
    }
    override func configureLayout() {
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(150)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        mySwitch.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom).offset(10)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        backView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(60)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(60)
        }
        signLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(60)
        }
        signButton.snp.makeConstraints { make in
            make.top.equalTo(signLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(60)
        }
        
        
    }
    func showAlert() {
        let alert = UIAlertController(title: "⚠️",
                                      message: "제대로 입력하셈",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인",
                               style: .destructive)
        let cancel = UIAlertAction(title: "취소",
                                   style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
}
