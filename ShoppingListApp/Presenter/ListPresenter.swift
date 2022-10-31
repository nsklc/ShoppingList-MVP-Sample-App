//
//  ListPresenter.swift
//  ShoppingListApp
//
//  Created by Enes Kılıç on 19.09.2021.
//

import Foundation
import RealmSwift

protocol ListViewPresenter: AnyObject {
    init(view: ItemsView)
    func notifyViewDidLoad()
    func addTapped(with title: String)
    func deleteSelected(for index: Int)
}

class ListPresenter: ListViewPresenter {
    
    weak var view: ItemsView?
    
    private var items: Results<Item>?
    private var realm = try! Realm()
    
    required init(view: ItemsView) {
        self.view = view
    }
    
    // MARK: - Protocol methods
    func notifyViewDidLoad() {
        print("View notifies the Presenter that it has loaded.")
        retrieveItems()
    }
    
    func addTapped(with title: String) {
        print("View notifies the Presenter that an add button was tapped.")
        addItem(title: title)
    }
    
    func deleteSelected(for index: Int) {
        print("View notifies the Presenter that a delete action was performed.")
        deleteItem(at: index)
    }
    
    // MARK: - Private methods
    private func retrieveItems() {
        print("Presenter retrieves Item objects from the Realm Database.")
        self.items = realm.objects(Item.self)
        
        let titles: [String]? = self.items?
            .compactMap { $0.title }
        view?.onItemsRetrieval(titles: titles ?? [])
    }
    
    private func addItem(title: String) {
        print("Presenter adds an Item object to the Realm Database.")
        let item = Item(title: title)
        do {
            try self.realm.write {
                self.realm.add(item)
            }
        } catch {
            view?.onItemAddFailure(message: error.localizedDescription)
        }
        view?.onItemAddSuccess(title: item.title)
    }
    
    private func deleteItem(at index: Int) {
        print("Presenter deletes an Item object from the Realm Database.")
        if let items = items {
            do {
                try self.realm.write {
                    self.realm.delete(items[index])
                }
            } catch {
                print("Couldn't delete an item")
            }
            view?.onItemDeletion(index: index)
        }
    }
    
}

