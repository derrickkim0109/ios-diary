//
//  Diary - DiaryListViewController.swift
//  Created by Hugh, Derrick on 2022/08/16.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    private enum Section {
        case main
    }
    
    private let jsonManager = JSONManager()
    
    private var dataSource: UITableViewDiffableDataSource<Section, DiaryContent>?
    
    private var contents = [DiaryContent]()
    
    private var changedRow = 0
    
    private let diaryListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefault()
        configureLayout()
        configureDataSource()
        fetchData()
    }
    
    private func setupDefault() {
        self.view.backgroundColor = .white
        self.view.addSubview(diaryListTableView)
        self.diaryListTableView.delegate = self
        
        self.title = "일기장"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTappedAddButton))
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, DiaryContent>(tableView: diaryListTableView, cellProvider: { tableView, indexPath, content -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier, for: indexPath) as? DiaryTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configureUI(data: content)
            cell.accessoryType = .disclosureIndicator
            
            return cell
        })
    }
    
    private func fetchData() {
        let fileName = "diarySample"
        let result = jsonManager.checkFileAndDecode(dataType: [DiaryContent].self, fileName)
        
        switch result {
        case .success(let contents):
            self.contents = contents
            updateDataSource(data: self.contents)
        case .failure(_):
            break
        default:
            break
        }
    }
    
    private func updateDataSource(data: [DiaryContent]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiaryContent>()
        snapshot.appendSections([.main])
        snapshot.appendItems(contents)
        
        dataSource?.apply(snapshot)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            diaryListTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            diaryListTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            diaryListTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            diaryListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func didTappedAddButton() {
        let addDiaryViewController = AddDiaryViewController()
        
        self.navigationController?.pushViewController(addDiaryViewController, animated: true)
    }
}

// MARK: TableVeiwDelegate

extension DiaryListViewController: UITableViewDelegate, ContentTextViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diaryContentViewController = DiaryContentViewController()
        diaryContentViewController.content = contents[indexPath.row]
        diaryContentViewController.delegate = self
        changedRow = indexPath.row
        self.navigationController?.pushViewController(diaryContentViewController, animated: true)
    }
    
    func contentTextViewDidChange(data: String, date: Double) {
        let array = data.split(separator: "\n", maxSplits: 2)
        let newTitle = String(array[0])
        let newBody = String(array[1])
        
        contents[changedRow].title = newTitle
        contents[changedRow].body = newBody
        
        updateDataSource(data: self.contents)
        diaryListTableView.reloadData()
    }
}
