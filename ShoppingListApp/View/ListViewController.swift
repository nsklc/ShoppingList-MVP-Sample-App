//
//  ViewController.swift
//  ShoppingListApp
//
//  Created by Enes Kılıç on 19.09.2021.
//

import UIKit

protocol ItemsView: AnyObject {
    func onItemsRetrieval(titles: [String])
    func onItemAddSuccess(title: String)
    func onItemAddFailure(message: String)
    func onItemDeletion(index: Int)
}

class ListViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: ListViewPresenter!
    var titles: [String] = []
    
    lazy var addBarItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        item.tintColor = .systemBlue
        return item
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame)
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textColor = .darkGray
        label.text = "No stored items yet"
        return label
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.notifyViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavItem()
    }
    
    // MARK: - Actions
    @objc func addTapped() {
        let alert = UIAlertController(title: "Add new Item", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let add = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let title = alert.textFields?.first!.text, !title.isEmpty {
                self?.presenter.addTapped(with: title)
            }
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Item's title"
        }
        
        alert.addAction(cancel)
        alert.addAction(add)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(placeholderLabel)
    }
    
    private func setupNavItem() {
        self.navigationItem.rightBarButtonItem = addBarItem
    }

}

// MARK: - View Protocol
extension ListViewController: ItemsView {
    
    func onItemsRetrieval(titles: [String]) {
        print("View recieves the result from the Presenter.")
        self.titles = titles
        tableView.reloadData()
    }
    
    func onItemAddSuccess(title: String) {
        print("View recieves the result from the Presenter.")
        titles.append(title)
        tableView.reloadData()
    }
    
    func onItemAddFailure(message: String) {
        print("View recieves a failure result from the Presenter: \(message)")
    }
    
    func onItemDeletion(index: Int) {
        print("View recieves a deletion result from the Presenter")
        titles.remove(at: index)
        tableView.reloadData()
    }
}

// MARK: - UITableView Data Source
extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.isHidden = titles.isEmpty
        placeholderLabel.isHidden = !titles.isEmpty
        
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteSelected(for: indexPath.row)
        }
    }
    
}
