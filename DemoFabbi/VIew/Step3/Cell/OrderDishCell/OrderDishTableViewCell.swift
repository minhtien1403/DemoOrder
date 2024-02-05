//
//  OrderDishTableViewCell.swift
//  DemoFabbi
//
//  Created by tientm on 04/02/2024.
//

import UIKit

protocol OrderDishTableViewCellDelegate: AnyObject {
    
    func addButtonDidTap()
    func previousButtonDidTap()
    func nextButtonDidTap()
}

class OrderDishTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var dishTextField: UITextField!
    @IBOutlet private weak var numberOfDishTextfield: UITextField!
    @IBOutlet private weak var decreaseButton: UIButton!
    @IBOutlet private weak var footerView: UIView!
    
    weak var delegate: OrderDishTableViewCellDelegate?
    private var selectedDish: String = ""
    private var numberOfDish: Int = 1
    var changeDishNumberButtonDidTap: (Int) -> Void = { _ in }
    var showListDish: () -> Void = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI() {
        dishTextField.isUserInteractionEnabled = false
        numberOfDishTextfield.isUserInteractionEnabled = false
        footerView.isHidden = true
        updateButtonState()
    }
    
    func setupData(dish: String, number: Int) {
        dishTextField.text = dish.isEmpty ? "---" : dish
        numberOfDishTextfield.text = "\(number)"
        numberOfDish = number
    }
    
    func showFooterView() {
        footerView.isHidden = false
    }
    
    @IBAction private func showDishListButtonDidTap(_ sender: UIButton) {
        showListDish()
    }
    
    @IBAction private func increaseButtonDidTap(_ sender: UIButton) {
        numberOfDish += 1
        numberOfDishTextfield.text = "\(numberOfDish)"
        updateButtonState()
        changeDishNumberButtonDidTap(numberOfDish)
    }
    
    @IBAction private func decreaseButtonDidTap(_ sender: UIButton) {
        numberOfDish -= 1
        numberOfDishTextfield.text = "\(numberOfDish)"
        updateButtonState()
        changeDishNumberButtonDidTap(numberOfDish)
    }
    @IBAction private func addButtonDidtap(_ sender: UIButton) {
        delegate?.addButtonDidTap()
    }
    
    @IBAction private func previousButtonDidTap(_ sender: UIButton) {
        delegate?.previousButtonDidTap()
    }
    
    @IBAction private func nextButtonDidTap(_ sender: UIButton) {
        delegate?.nextButtonDidTap()
    }
    
    private func updateButtonState() {
        decreaseButton.isEnabled = numberOfDish > 1
    }
}
