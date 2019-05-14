//
//  ViewController.swift
//  DrawingApp
//
//  Created by Crafter on 4/7/19.
//  Copyright © 2019 Crafter. All rights reserved.
//

import UIKit


struct Constants {
    static var flipCardAnimationDuration: TimeInterval = 0.6
    static var matchCardAnimationDuration: TimeInterval = 0.6
    static var matchCardAnimationScaleUp: CGFloat = 3.0
    static var matchCardAnimationScaleDown: CGFloat = 0.1
    static var behaviorResistance: CGFloat = 0
    static var behaviorElasticity: CGFloat = 1.0
    static var behaviorPushMagnitudeMinimum: CGFloat = 1
    static var behaviorPushMagnitudeRandomFactor: CGFloat = 1.5
    static var behaviorFriction: CGFloat = 0
    static var cardsPerMainViewWidth: CGFloat = 5
}


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private lazy var animator = UIDynamicAnimator(referenceView: view)
    private lazy var cardBehavior = CardBehavior(in: animator)
    
    var flipCount = 0
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear

        eventsSubscription()
        viewBack.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
    }
    
    @IBOutlet var myViews: [MyView]!
    
    @IBOutlet weak var viewBack: MyView!
    
    @IBAction func changeImageClick(_ sender: Any) {
        goPicker()
    }
    
    @IBAction func setDefaultImageClick(_ sender: Any) {
        viewBack.isCustomImage = false
    }
    
    
    
    private func eventsSubscription () {
        for i in 0..<myViews.count {
            myViews[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedHandler(tap:))))
            cardBehavior.addItem(myViews[i])
        }
        
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewBackTapHandler(tap:))))
    }
    
     @objc func tappedHandler(tap: UITapGestureRecognizer) {
        let myView = tap.view as? MyView

        if let figureSides = myView?.sides {
            viewBack.sides = figureSides
        }
                    
     
        stopViewMoving()
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.6,
            delay: 0,
            options: [],
            animations: {[weak self] in
                self?.viewBack.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        })
    }
    
    
    func stopViewMoving() {
        viewBack.isHidden = false
        for view in myViews{
        view.isHidden = true
        cardBehavior.removeItem(view)
        }
    }
    
    func startViewMoving() {
        viewBack.isHidden = true
        for view in myViews {
         view.isHidden = false
        cardBehavior.addItem(view)
        }
    
    }
    
    @objc func viewBackTapHandler(tap: UITapGestureRecognizer) {
        switch tap.state {
        case .ended:
            let myView = tap.view as? MyView
            
            UIView.transition(
                with: viewBack,
                duration: 0.6,
                options: [.transitionFlipFromLeft],
                animations: {
                    myView?.isViewBack = !myView!.isViewBack
                    self.flipCount += 1 },
                completion: { [weak self] _ in
                    if(self?.flipCount == 2){
                        self?.flipCount = 0
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 0.6,
                            delay: 0,
                            options: [],
                            animations: {[weak self] in
                                self?.viewBack.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                            }, completion: { _ in
                                self?.startViewMoving()
                        })
                    }
            })
        default:
            break
        }        
    }

    
    @objc func viewBackSwipeHandler(tap: UISwipeGestureRecognizer) {
        let myView = tap.view as? MyView
      
        let coords = myView?.frame.origin
        
        myView?.transform = CGAffineTransform.identity.translatedBy(x: myView?.frame.size.width ?? 0, y: myView?.frame.size.height ?? 0)
            .rotated(by: CGFloat.pi)
        
        myView?.frame.origin = coords ?? CGPoint(x: 0, y: 0)
    }
    
    @objc func goPicker() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary;
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        viewBack.isCustomImage = true
        viewBack.customImage = image
        dismiss(animated: true, completion: nil)
    }
    
}

