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
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent // .default
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
    cell.checkBox.addTarget(self, action: #selector(doneTapped(_:event:)), for: .touchUpInside)
    return cell
  }
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if isRemoving {
      let selected = viewModels[indexPath.row]
      // Deleting persistent queue
      let deleteQueue = DispatchQueue.global(qos: .utility)
      deleteQueue.async {
        self.todoStore.deletePersistedTodo(entityId: selected.entityId)
      }
      DispatchQueue.main.async {
        collectionView.performBatchUpdates({
          self.viewModels.remove(at: indexPath.row)
          collectionView.deleteItems(at: [indexPath])
          self.todoStore.saveContext()
        }, completion: nil)
      }
    } else {
      let selectedTodo = viewModels[indexPath.row]
      let detailVC = TodoDetailViewController()
      detailVC.todoId = selectedTodo.entityId
      detailVC.todo = Todo(title: selectedTodo.title,
                           description: (selectedTodo.description != nil) ? selectedTodo.description! : nil,
                           done: selectedTodo.done,
                           color: selectedTodo.color)
      detailVC.todoStore = todoStore
      navigationController?.pushViewController(detailVC, animated: true)
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
  
  // MARK: Check box button
  @objc func doneTapped(_ sender: UIButton, event: UIEvent) {
    guard let touch = event.allTouches?.first else { return }
    // Get the point of where the user touched
    let touchPosition: CGPoint = (touch.location(in: self.collectionView))
    
    // Get the index path of the cell from the point of where the user touched
    guard let indexPath = self.collectionView.indexPathForItem(at: touchPosition) else { return }
    
    if let cell = collectionView.cellForItem(at: indexPath) as? TodoCollectionViewCell {
      // Change the color of the check box
      UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
        cell.checkBox.backgroundColor = .green
        cell.checkBox.layer.borderWidth = 0
      }, completion: { _ in
        // Delete the Todo once the check box animation finished
        DispatchQueue.global(qos: .utility).async {
          self.todoStore.deletePersistedTodo(entityId: self.viewModels[indexPath.row].entityId)
        }
        
        DispatchQueue.main.async {
          self.collectionView.performBatchUpdates({
            self.viewModels.remove(at: indexPath.row)
            self.collectionView.deleteItems(at: [indexPath])
            self.todoStore.saveContext()
          }, completion: nil)
        }
      })
    }
  }
}
// MARK: Core Data functions
extension MainCollectionViewController {
  // Update the collectionView's datasource
  private func populatePersistent() {
    // Populate persistent queue
    let populateQueue = DispatchQueue.global(qos: .userInteractive)
    populateQueue.async {
      self.todoStore.fetchPersistedData { (result) in
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
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
      }
    }
  }
}
// MARK: AddTodoDelegate
extension MainCollectionViewController: AddTodo {
  func addTodo(todo: Todo) {
    let newTodo = todoStore.createTodo(todo: todo)
    let saveQueue = DispatchQueue.global(qos: .userInitiated)
    saveQueue.async {
      if let todo = newTodo {
        self.viewModels.append(TodoViewModel.init(todo: todo))
      }
    }
  }
}
