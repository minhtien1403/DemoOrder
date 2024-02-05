//
//  ReviewViewController.swift
//  DemoFabbi
//
//  Created by tientm on 02/02/2024.
//

import UIKit

protocol ReviewViewControllerDelegate: AnyObject {
    
    func backToStep3()
}

class ReviewViewController: UIViewController {
    
    @IBOutlet private weak var medalLabel: UILabel!
    @IBOutlet private weak var noOfPeopleLabel: UILabel!
    @IBOutlet private weak var restaurentLabel: UILabel!
    @IBOutlet private weak var dishesLabel: UILabel!
    @IBOutlet private weak var headerView: UIView!
    
    weak var dataSource: OrderFlowDataSource?
    weak var delegate: ReviewViewControllerDelegate?
    
    private var orderInfo = MultiTypeDictionary<Order>()
    private var order: Order?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderInfo = dataSource?.getOrderData() ?? MultiTypeDictionary<Order>()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        orderInfo = dataSource?.getOrderData() ?? MultiTypeDictionary<Order>()
        setupUI()
    }
    
    func setupUI() {
        guard let medal = orderInfo[\.medal],
              let noOfPeople = orderInfo[\.numberOfPeople],
              let restaurents = orderInfo[\.restaurents],
              let dishes = orderInfo[\.dishes] else {
            return
        }
        headerView.layer.cornerRadius = 8
        order = Order(medal: medal, numberOfPeople: noOfPeople, restaurents: restaurents, dishes: dishes)
        medalLabel.text = medal
        noOfPeopleLabel.text = "\(noOfPeople)"
        restaurentLabel.text = restaurents
        dishesLabel.text = dishes
            .map { "\($0.dish) - \($0.number)" }
            .joined(separator: "\n")
    }
    
    @IBAction private func previousButtonDidTap(_ sender: UIButton) {
        delegate?.backToStep3()
    }
    
    @IBAction private func reviewButtonDidTap(_ sender: UIButton) {
        if let order = order {
            print(order)
        }
    }
}
