//
//  ViewController.swift
//  RxSwiftPractice
//
//  Created by dopamint on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController {
    
    let tableView = UITableView()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // MARK: Observable
        let items = Observable.just([
            "첫번째 셀",
            "지각",
            "안되"
        ])
        intervalFrom()
        // MARK: Observer : 테이블뷰에 데이터를 보여주는 형태로 이벤트를 처리하고 있음
        // 그나마 closure 구문이 Observer..
        // bind == subscribe
        items
            .take(1)
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                
                cell.textLabel?.text = "\(element) @ row \(row)"
                return cell
            }
            .disposed(by: disposeBag) // subscribe 가 취소되는 부분
        
        tableView.rx.itemSelected
            .bind { value in
                print("\(value)가 선택되었어요.")
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .bind { value in
                print("\(value)가 선택되었어요.")
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected,
                       tableView.rx.modelSelected(String.self))
        .bind { value in
            print(value.0, value.1)
            
        }
        .disposed(by: disposeBag)
    }
    
    func textJust() {
        Observable.just([1,2,3]) // finite obsevable sequence
            .subscribe { value in
                print("next: \(value)")
            } onError: { error in
                print("error")
            } onCompleted: {
                print("complete")
            } onDisposed: {
                print("dispose")
            }
            .disposed(by: disposeBag)
    }    
    func textFrom() {
        Observable.from([1,2,3]) // finite obsevable sequence
            .subscribe { value in
                print("next: \(value)")
            } onError: { error in
                print("error")
            } onCompleted: {
                print("complete")
            } onDisposed: { // event는 아님
                print("dispose")
            }
            .disposed(by: disposeBag)
    }
    func intervalFrom() {
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance) //  infinite obsevable sequence
            .subscribe { value in
                print("next: \(value)")
            } onError: { error in
                print("error")
            } onCompleted: {
                print("complete")
            } onDisposed: {
                print("dispose")
            }
            .disposed(by: disposeBag)
    }
    
    
    
    func configureHierarchy() {
        view.addSubview(tableView)
    } 
    func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//let array = [1, 2, 3, 4, 5, 6]
//
//let result = array.filter  { $0 % 2 == 0 }

//print(result)
////
//let result = array
//    .filter { $0 % 2 == 0 }
//    .map { $0 * 2 }
//    .map { "\($0)일" }


