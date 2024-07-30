//
//  RxTableViewController.swift
//  RxSwiftPractice
//
//  Created by dopamint on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class RxTableViewController: RxBaseViewController {
    
    let simpleTableView = UITableView()

        override func viewDidLoad() {
            super.viewDidLoad()
            simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            let items = Observable.just(
                (0..<20).map { "\($0)" }
            )
            
            items
                .bind(to: simpleTableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                    cell.textLabel?.text = "\(element) @ row \(row)"
                }
                .disposed(by: disposeBag)
        
            simpleTableView.rx
                .modelSelected(String.self)
                .subscribe(onNext:  { value in
                    print("Tapped `\(value)`")
                })
                .disposed(by: disposeBag)
            
            simpleTableView.rx
                .itemAccessoryButtonTapped
                .subscribe(onNext: { indexPath in
                    print("Tapped Detail @ \(indexPath.section),\(indexPath.row)")
                })
                .disposed(by: disposeBag)
            
        }
        
        override func configureHierarchy() {
            view.addSubview(simpleTableView)
        }
        override func configureLayout() {
            simpleTableView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
