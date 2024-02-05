//
//  StepOneViewController.swift
//  DemoFabbi
//
//  Created by tientm on 02/02/2024.
//

import UIKit

protocol StepOneViewControllerDelegate: AnyObject {
    
    func nextButtonDidTap(medal: String, numberOfPeople: Int)
}

class StepOneViewController: UIViewController {
    
    @IBOutlet private weak var medalTextField: UITextField!
    @IBOutlet private weak var numberOfPeopleTextField: UITextField!
    @IBOutlet private weak var increasePeopleButton: UIButton!
    @IBOutlet private weak var decreasePeopleButton: UIButton!
    private let maxNumberOfPeople = 10
    private let minNumberOfPeople = 1
    private var numberOfPeople: Int = 1
    private let mealsMedal = MealMedal.allCases
    private var selectedMedal: MealMedal?
    
    private let notificationCenter = NotificationCenterServices.shared
    
    weak var delegate: StepOneViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        medalTextField.isUserInteractionEnabled = false
        numberOfPeopleTextField.isUserInteractionEnabled = false
        updateButtonState()
    }

    @IBAction private func medalButtonDidtap(_ sender: UIButton) {
        let alert = UIAlertController(title: "Meal", message: nil, preferredStyle: .actionSheet)
        for medal in mealsMedal {
            alert.addAction(UIAlertAction(title: medal.rawValue, style: .default, handler: { [weak self] action in
                if medal != self?.selectedMedal {
                    self?.notificationCenter.post(name: AppNotification.medalDidChange.name, object: nil)
                }
                self?.selectedMedal = medal
                self?.medalTextField.text = medal.rawValue
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        self.present(alert, animated: true)
    }
    
    @IBAction private func increasePeopleButtonDidTap(_ sender: UIButton) {
        if numberOfPeople < maxNumberOfPeople {
            numberOfPeople += 1
            numberOfPeopleTextField.text = "\(numberOfPeople)"
            updateButtonState()
        }
    }
    
    @IBAction private func decreasePeopleButtonDidTap(_ sender: UIButton) {
        if numberOfPeople > minNumberOfPeople {
            numberOfPeople -= 1
            numberOfPeopleTextField.text = "\(numberOfPeople)"
            updateButtonState()
        }
    }
    
    @IBAction private func nextButtonDidTap(_ sender: UIButton) {
        if let medal = selectedMedal {
            delegate?.nextButtonDidTap(medal: medal.rawValue, numberOfPeople: numberOfPeople)
        } else {
            let alert = UIAlertController(title: "Medal Required", message: "Please select a medal", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    private func updateButtonState() {
        increasePeopleButton.isEnabled = numberOfPeople < maxNumberOfPeople
        decreasePeopleButton.isEnabled = numberOfPeople > minNumberOfPeople
    }
}

enum MealMedal: String, CaseIterable {
    
    case breakfast
    case lunch
    case dinner
}
