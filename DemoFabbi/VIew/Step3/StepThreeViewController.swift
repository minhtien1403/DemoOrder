//
//  StepThreeViewController.swift
//  DemoFabbi
//
//  Created by tientm on 02/02/2024.
//

import UIKit

protocol StepThreeViewControllerDelegate: AnyObject {
    
    func previousButtonDidTapInStep3()
    func nextButtonDidTap(dishSelected: [(dish: String, number: Int)])
}

enum OrderValidation {
    case valid
    case notSelectAllDishYet
    case notOrderEnoughDishYet
}

class StepThreeViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    weak var delegate: StepThreeViewControllerDelegate?
    private var orderInfo = MultiTypeDictionary<Order>()
    private let maxDish = 10
    private var minDish = 1
    private var dishes: [Dish] = []
    private var dishSelected: [(dish: String, number: Int)] = [("", 1)]
    private let notificationCenter = NotificationCenterServices.shared
    
    weak var dataSource: OrderFlowDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        orderInfo = dataSource?.getOrderData() ?? MultiTypeDictionary<Order>()
        minDish = orderInfo[\.numberOfPeople] ?? 1
        dishes = dataSource?.getDishesData() ?? []
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    private func resetData() {
        dishSelected = [("", 1)]
        tableView.reloadData()
    }
    
    private func setupUI() {
        tableView.registerCell(OrderDishTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
    }
    
    private func setupObserver() {
        notificationCenter.addObserver(self,
                                       selector: #selector(onNotificationReceived(_:)),
                                       name: AppNotification.restaurenDidChange.name,
                                       object: nil)
    }
    
    @objc
    private func onNotificationReceived(_ notification: Notification) {
        switch notification.name {
        case AppNotification.restaurenDidChange.name:
            resetData()
        default:
            break
        }
    }
    
    private func validateOrder() -> OrderValidation {
        for dishSelect in dishSelected {
            if dishSelect.dish.isEmpty {
                return .notSelectAllDishYet
            }
        }
        if dishSelected.count < minDish {
            return .notOrderEnoughDishYet
        }
        return .valid
    }
}

extension StepThreeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dishSelected.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: OrderDishTableViewCell.self, for: indexPath)
        cell.delegate = self
        cell.setupUI()
        cell.setupData(dish: dishSelected[indexPath.row].dish, number: dishSelected[indexPath.row].number)
        if indexPath.row == dishSelected.count - 1 { cell.showFooterView() }
        cell.changeDishNumberButtonDidTap = { [weak self] value in
            self?.dishSelected[indexPath.row].number = value
        }
        cell.showListDish = { [weak self] in self?.showDishListButtonDidTap(index: indexPath.row) }
        return cell
    }
}

extension StepThreeViewController: OrderDishTableViewCellDelegate {
    
    func addButtonDidTap() {
        if dishSelected.count < maxDish {
            dishSelected.append(("", 1))
            tableView.reloadData()
        } else {
            let alert = UIAlertController(title: "Max exceed", message: "You can only order 10 dish", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    func previousButtonDidTap() {
        delegate?.previousButtonDidTapInStep3()
    }
    
    func nextButtonDidTap() {
        switch validateOrder() {
        case .valid:
            delegate?.nextButtonDidTap(dishSelected: dishSelected)
        case .notOrderEnoughDishYet:
            let alert = UIAlertController(title: "Not select enough dish", message: "Select at least \(minDish) for \(minDish) person", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        case .notSelectAllDishYet:
            let alert = UIAlertController(title: "Please select all dish", message: "Some dish not selected yet", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    func showDishListButtonDidTap(index: Int) {
        let restaurent = orderInfo[\.restaurents]
        let availableDish = dishes
            .filter { $0.restaurant == restaurent }
            .map { $0.name }
            .filter { !dishSelected.map { $0.dish }.contains($0) }
        let alert = UIAlertController(title: "Dish", message: nil, preferredStyle: .actionSheet)
        for dish in availableDish {
            alert.addAction(UIAlertAction(title: dish, style: .default, handler: { [weak self] actiom in
                self?.dishSelected[index].dish = dish
                self?.tableView.reloadData()
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
}
