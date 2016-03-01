//
//  ViewController.swift
//  FloCGDemo
//
//  Created by Junna on 2/15/16.
//  Copyright © 2016 Junna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadDataItems()
        
        self.view.addSubview(backgroundView)
        self.view.addSubview(containerView)
        containerView.addSubview(counterView)
        counterView.counter = viewModel.todayCounter
        
        self.view.addSubview(plusButton)
        self.view.addSubview(subtractButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        backgroundView.width = self.view.width
        backgroundView.height = self.view.height
        backgroundView.top = 0.0
        backgroundView.left = 0.0
        
        let centerX  = self.view.width / 2
        
        plusButton.centerX = centerX
        plusButton.centerY = self.view.height / 2 + 100
        
        subtractButton.centerX = centerX
        subtractButton.centerY = plusButton.centerY + 100
        
        containerView.top = self.view.height * 0.03
        containerView.centerX = centerX
        counterView.centerX = containerView.width / 2
        counterView.centerY = containerView.height / 2
        graphView.center = counterView.center
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        graphView.scrollToItemAtIndexPath(NSIndexPath(forRow: graphView.collection.count - 1, inSection: 0), atScrollPosition: .None, animated: false)
    }
    
    func plus() {
        if !displayingPrimary {
            flip()
        }
        counterView.counter++
        viewModel.save(counterView.counter)
        if counterView.counter != 8 {
            FDUtils.schedulLocalNotification()
        }
    }
    
    func subtract() {
        if !displayingPrimary {
            flip()
        }
        counterView.counter--
        viewModel.save(counterView.counter)
        FDUtils.schedulLocalNotification()
    }
    
    func reloadGraphView() {
        graphView.collection = viewModel.counters
    }
    
    private var displayingPrimary : Bool = true
    func flip() {
        UIView.transitionFromView(displayingPrimary ? counterView : graphView,
            toView: displayingPrimary ? graphView : counterView,
            duration: 1.0,
            options: .TransitionFlipFromLeft,
            completion: { [weak self](finished) -> Void in
                if let strongSelf = self {
                    strongSelf.displayingPrimary = !strongSelf.displayingPrimary
                }
            })
    }
    
    lazy var viewModel: ViewModel = {
        let model = ViewModel()
        model.delegate = self
        return model
    }()

    lazy var backgroundView: BackgroundView = {
        let view = BackgroundView(frame: CGRectZero)
        return view
    }()
    
    lazy var plusButton: PushButton = {
        let button = PushButton(frame: CGRectMake(0, 0, 100, 100))
        button.addTarget(self, action: "plus", forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var subtractButton: PushButton = {
        let button = PushButton(frame: CGRectMake(0, 0, 50, 50), type: .Subtract)
        button.addTarget(self, action: "subtract", forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var containerView: UIView = {
        let view = UIView(frame: CGRectMake(0, 0, 300, 300))
        view.backgroundColor = UIColor.clearColor()
        let gr = UITapGestureRecognizer(target: self, action: "flip")
        view.addGestureRecognizer(gr)
        return view
    }()
    
    lazy var counterView: CounterView = {
        let view = CounterView(frame: CGRectMake(0, 0, 230, 230))
        return view
    }()
    
    lazy var graphView: GraphCollectionView = {
        let view = GraphCollectionView(frame: CGRectMake(0, 0, 300, 230))
        view.backgroundColor = UIColor.clearColor()
        return view
    }()
}

