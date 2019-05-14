//
//  MyView.swift
//  DrawingApp
//
//  Created by Crafter on 4/8/19.
//  Copyright © 2019 Crafter. All rights reserved.
//

import UIKit


class MyView : UIView {
    
    @IBInspectable
    var sides: Int = 0 {
        didSet{
            setNeedsDisplay(); setNeedsLayout()
        }
    }
    
    var isViewBack = true {
        didSet{
            setNeedsDisplay(); setNeedsLayout()
        }
    }
    
    var isCustomImage = false

    var customImage: UIImage?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        if(isViewBack) {
        if sides > 2 {
            drawFigure(context: context, rect: rect, sides: sides)
        }
        drawText(rect: rect, text: String(sides))
        } else {
            if(isCustomImage) {
                if let backImage = customImage {
                    backImage.draw(in: bounds)
               }
            }
            else {
                if let backImage = UIImage(named: "cardback"){
                    backImage.draw(in: bounds)
                }
            }
        }
    }
    
    func drawFigure(context: CGContext, rect: CGRect, sides: Int){
        
        let radius = Double(rect.maxX - rect.minX)/2
        let length = sin(Double.pi / Double(sides)) * 2.0 * radius
        let angle = -360.0/Double(sides)
        let constPoint = (x: Double(rect.maxX/2) + length/2, y: Double(rect.maxY) - 15)
        var point = constPoint
        
        var pointArr : [CGPoint] = []
        pointArr.append(CGPoint(x: point.x, y: point.y))
        
        context.move(to: CGPoint(x: point.x, y: point.y))
        
        for i in 1...sides{
            
            let sinFi = sin(Double(i) * angle * Double.pi / 180.0)
            let cosFi = cos(Double(i) * angle * Double.pi / 180.0)
            
            point.x = point.x + length * cosFi
            point.y = point.y + length * sinFi
            
            let tempPoint = CGPoint(x: point.x, y: point.y)
            pointArr.append(tempPoint)
            context.addLine(to: tempPoint)
        }
        
        context.setFillColor(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1))
        context.fillPath();
        
        context.setLineWidth(3)
        context.setStrokeColor(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
        context.addLines(between: pointArr)
        context.strokePath()
    }
    
    func drawText(rect: CGRect, text: String){
        let textRect = CGRect(x: (rect.maxX / 2) - 7, y: (rect.maxY / 2), width: 25, height: 25)
        let attribute: [NSAttributedString.Key : Any] = [.font: UIFont.preferredFont(forTextStyle: .body).withSize(20)]
        (text as NSString).draw(in: textRect, withAttributes: attribute)
    }
    
    
}

