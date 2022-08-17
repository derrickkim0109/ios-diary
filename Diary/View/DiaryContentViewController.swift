//
//  DiaryContentViewController.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/17.
//

import UIKit

final class DiaryContentViewController: UIViewController {
    var content: DiaryContent?
    var delegate: ContentTextViewDelegate?
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = true
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(textView)
        self.title = content?.createdAt.formattedDate
        configureLayout()
        setupTextView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.contentTextViewDidChange(data: textView.text, date: content!.createdAt)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            textView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            textView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTextView() {
        guard let content = content else { return }
        let newText = content.title + "\n" + "\n" + content.body
        textView.text = newText
    }
}

protocol ContentTextViewDelegate {
    func contentTextViewDidChange(data: String, date: Double)
}
