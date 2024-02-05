//
//  StepTwoViewController.swift
//  DemoFabbi
//
//  Created by tientm on 02/02/2024.
//

import UIKit

protocol StepTwoViewControllerDelegate: AnyObject {
    
    func previousButtonDidTap()
    func nextButtonDidTap(restaurent: String)
}

class StepTwoViewController: UIViewController {
    
    @IBOutlet private weak var restaurentTextField: UITextField!
    
    weak var delegate: StepTwoViewControllerDelegate?
    weak var datasouce: OrderFlowDataSource?
    private var dishes: [Dish] = []
    private var orderInfo = MultiTypeDictionary<Order>()
    private var selectedRestaurent: String = ""
    private let notificationCenter: NotificationCenterServices = NotificationCenterServices.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        orderInfo = datasouce?.getOrderData() ?? MultiTypeDictionary<Order>()
        dishes = datasouce?.getDishesData() ?? []
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    func resetData() {
        selectedRestaurent = ""
        restaurentTextField.text = "---"
    }
    
    func setupObserver() {
        notificationCenter.addObserver(self,
                                       selector: #selector(onNotificationReceived(_:)),
                                       name: AppNotification.medalDidChange.name,
                                       object: nil)
    }
    
    @objc
    private func onNotificationReceived(_ notification: Notification) {
        switch notification.name {
        case AppNotification.medalDidChange.name:
            resetData()
        default:
            break
        }
    }
    
    
    private func setupUI() {
        restaurentTextField.isUserInteractionEnabled = false
    }
    
    @IBAction private func selectRestaurentButtonDidTap() {
        let restaurents = dishes
            .filter { $0.availableMeals.contains(orderInfo[\.medal] ?? "") }
            .map { $0.restaurant }
            .uniqued()
        let alert = UIAlertController(title: "Restaurent", message: nil, preferredStyle: .actionSheet)
        for restaurent in restaurents {
            alert.addAction(UIAlertAction(title: restaurent, style: .default, handler: { [weak self] action in
                if restaurent != self?.selectedRestaurent {
                    self?.notificationCenter.post(name: AppNotification.restaurenDidChange.name, object: nil)
                }
                self?.selectedRestaurent = restaurent
                self?.restaurentTextField.text = restaurent
            } ))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @IBAction private func previousButtonDidTap(_ sender: UIButton) {
        delegate?.previousButtonDidTap()
    }
    
    @IBAction private func nextButtonDidTap(_ sender: UIButton) {
        if !selectedRestaurent.isEmpty {
            delegate?.nextButtonDidTap(restaurent: selectedRestaurent)
        } else {
            let alert = UIAlertController(title: "Restaurent Required", message: "Please select a restaurent", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
