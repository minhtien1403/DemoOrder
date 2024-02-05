//
//  ViewController.swift
//  DemoFabbi
//
//  Created by tientm on 02/02/2024.
//

import UIKit

enum Step: Int {
    
    case step1 = 0
    case step2 = 1
    case step3 = 2
    case review = 3
}

protocol OrderFlowDataSource: AnyObject {
    
    func getDishesData() -> [Dish]
    func getOrderData() -> MultiTypeDictionary<Order>
}

class ViewController: UIViewController {
    
    @IBOutlet private weak var segmentView: UIView!
    @IBOutlet private weak var step1Label: UILabel!
    @IBOutlet private weak var step2Label: UILabel!
    @IBOutlet private weak var step3Label: UILabel!
    @IBOutlet private weak var step4Label: UILabel!
    
    private var selectedStep: Step = .step1
    private var pageViewController: UIPageViewController!
    private var orderInfo = MultiTypeDictionary<Order>()
    private var pages: [UIViewController] = []
    private var dishes: [Dish] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageController()
        updateSegmentView()
        getData()
    }

    private func setupPageController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController?.view.backgroundColor = .clear
        pageViewController?.view.frame = CGRect(x: 0,
                                                y: segmentView.height + UIApplication.shared.statusBarFrame.height + 10,
                                                width: view.width,
                                                height: view.height)
        let step1vc = StepOneViewController()
        step1vc.delegate = self
        let step2Vc = StepTwoViewController()
        step2Vc.delegate = self
        step2Vc.datasouce = self
        let step3Vc = StepThreeViewController()
        step3Vc.dataSource = self
        step3Vc.delegate = self
        let step4Vc = ReviewViewController()
        step4Vc.dataSource = self
        step4Vc.delegate = self
        pages = [step1vc, step2Vc, step3Vc, step4Vc]
        pageViewController.setViewControllers([pages[selectedStep.rawValue]], direction: .forward, animated: true)
        pageViewController.didMove(toParent: self)
        
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
    }

    private func updateSegmentView(direction: UIPageViewController.NavigationDirection = .forward) {
        step1Label.tag = 0
        step2Label.tag = 1
        step3Label.tag = 2
        step4Label.tag = 3
        [step1Label, step2Label, step3Label, step4Label].forEach {
            $0?.backgroundColor = $0?.tag == selectedStep.rawValue ? .blue : .white
            $0?.textColor = $0?.tag == selectedStep.rawValue ? .white : .black
        }
        pageViewController.setViewControllers([pages[selectedStep.rawValue]], direction: direction, animated: true)
    }
    
    private func getData() {
        if let path = Bundle.main.path(forResource: "dishes", ofType: "json") {
            guard let data = (try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)) else {
                return
            }
            let decoder = JSONDecoder()
            guard let data = try? decoder.decode(Dishes.self, from: data) else {
                return
            }
            dishes = data.dishes
        }
    }
}

extension ViewController: OrderFlowDataSource {
    
    func getDishesData() -> [Dish] {
        dishes
    }
    
    func getOrderData() -> MultiTypeDictionary<Order> {
        orderInfo
    }
}

extension ViewController: StepOneViewControllerDelegate {
    
    func nextButtonDidTap(medal: String, numberOfPeople: Int) {
        orderInfo[\.medal] = medal
        orderInfo[\.numberOfPeople] = numberOfPeople
        selectedStep = .step2
        updateSegmentView()
    }
}

extension ViewController: StepTwoViewControllerDelegate {
    
    func nextButtonDidTap(restaurent: String) {
        orderInfo[\.restaurents] = restaurent
        selectedStep = .step3
        updateSegmentView()
    }
    
    func previousButtonDidTap() {
        selectedStep = .step1
        updateSegmentView(direction: .reverse)
    }
}

extension ViewController: StepThreeViewControllerDelegate {

    func nextButtonDidTap(dishSelected: [(dish: String, number: Int)]) {
        orderInfo[\.dishes] = dishSelected
        selectedStep = .review
        updateSegmentView()
    }
    
    func previousButtonDidTapInStep3() {
        selectedStep = .step2
        updateSegmentView(direction: .reverse)
    }
}

extension ViewController: ReviewViewControllerDelegate {
    
    func backToStep3() {
        selectedStep = .step3
        updateSegmentView(direction: .reverse)
    }
}
