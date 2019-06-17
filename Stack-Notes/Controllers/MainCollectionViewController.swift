//
//  MainCollectionViewController.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/10/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController {
    // MARK: Variables
    var todoStore: TodoStore!
    var viewModels: [TodoViewModel] = []
    var isRemoving = false
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        // Register cell classes
        self.collectionView!.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
        setupSelfView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavBar()
        viewModels = []
        todoStore.saveContext()
        populatePersistent()
    }
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModels.count == 0 {
            setupEmptyView()
        } else {
            self.collectionView.restore()
        }
        return viewModels.count
    }
    // MARK: CellForItemAt
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TodoCollectionViewCell
        let todo = viewModels[indexPath.row]
        cell.backgroundColor = todo.color
        cell.titleLabel.text = todo.title
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isRemoving {
            let selected = viewModels[indexPath.row]
            todoStore.deletePersistedTodo(entityId: selected.entityId)
            collectionView.performBatchUpdates({
                viewModels.remove(at: indexPath.row)
                collectionView.deleteItems(at: [indexPath])
                todoStore.saveContext()
            }, completion: nil)
        } else {
            return
        }
    }
}

// MARK: UI Functions
extension MainCollectionViewController {
    private func setupEmptyView() {
        let emptyView = EmptyView(frame: self.view.bounds)
        self.collectionView.backgroundView = emptyView
    }
    private func setupSelfView() {
        collectionView.backgroundColor = .mainBackgroundGray
    }
    private func configNavBar() {
        self.title = "Todos"
        // Color of the nav bar
        navigationController?.navigationBar.barTintColor = .mainNavBarBlack
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        // Nav bar buttons
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashTapped))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = deleteButton
    }
}


// MARK: Objc functions
extension MainCollectionViewController {
    @objc private func addButtonTapped() {
        let addTodoVC = AddTodoViewController()
        addTodoVC.delegate = self
        navigationController?.pushViewController(addTodoVC, animated: true)
    }
    @objc private func trashTapped() {
        isRemoving = true
        let doneRemovingButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneRemoving))
        navigationItem.leftBarButtonItem = doneRemovingButton
        navigationItem.rightBarButtonItem = nil
        self.collectionView.reloadData()
    }
    @objc private func doneRemoving() {
        isRemoving = false
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashTapped))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = deleteButton
        self.collectionView.reloadData()
    }
}
// MARK: Core Data functions
extension MainCollectionViewController {
    // Update the collectionView's datasource
    private func populatePersistent() {
        todoStore.fetchPersistedData { (result) in
            switch result {
            case .success(let listOfTodos):
                listOfTodos.forEach({ (persistent) in
                    self.viewModels.append(TodoViewModel.init(todo: persistent))
                })
            case .failure(let error):
                print(error)
                self.viewModels.removeAll()
            }
            // reload the collectionView's data source to present the current data set
            self.collectionView.reloadData()
        }
    }
}
// MARK: AddTodoDelegate
extension MainCollectionViewController: AddTodo {
    func addTodo(todo: Todo) {
        let newTodo = NSEntityDescription.insertNewObject(forEntityName: "TodoPersistent", into: todoStore.persistentContainer.viewContext) as? TodoPersistent
        print(todo)
        newTodo?.color = todo.color
        newTodo?.title = todo.title
        newTodo?.taskDescription = todo.description
        newTodo?.done = todo.done
        if let todo = newTodo {
            viewModels.append(TodoViewModel.init(todo: todo))
        }
    }
}
