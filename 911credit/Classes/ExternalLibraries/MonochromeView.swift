//
//  MonochromeView.swift
//  Speedometer
//
//  Created by Anirudha on 13/02/18.
//  Copyright © 2018 Anirudha Mahale. All rights reserved.
//

import UIKit
struct Angle {
    let startAngle: CGFloat
    let endAngle: CGFloat
    let color: UIColor
    var duration: Double
}

class MonochromeView: UIView {
    // MonoChromeArc Properties
    
    var data = [Angle(startAngle: 0.0, endAngle: 0.31, color: #colorLiteral(red: 0.8, green: 0.09411764706, blue: 0.09411764706, alpha: 1), duration: 0.0),
                Angle(startAngle: 0.32, endAngle: 0.33, color: .white, duration: 0.0),
                
                Angle(startAngle: 0.34, endAngle: 0.43, color: #colorLiteral(red: 1, green: 0.337254902, blue: 0.337254902, alpha: 1), duration: 0.0),
                Angle(startAngle: 0.44, endAngle: 0.45, color: .white, duration: 0.0),
                
                Angle(startAngle: 0.46, endAngle: 0.56, color: #colorLiteral(red: 1, green: 0.7960784314, blue: 0, alpha: 1), duration: 0.0),
                Angle(startAngle: 0.57, endAngle: 0.58, color: .white, duration: 0.0),
                
                Angle(startAngle: 0.59, endAngle: 0.73, color: #colorLiteral(red: 0.1607843137, green: 0.937254902, blue: 0.5843137255, alpha: 1), duration: 0.0),
                Angle(startAngle: 0.74, endAngle: 0.75, color: .white, duration: 0.0),
                
                Angle(startAngle: 0.76, endAngle: 1.0, color: #colorLiteral(red: 0.1921568627, green: 0.8509803922, blue: 0.5490196078, alpha: 1), duration: 0.0)]

    // User Properties
    private var pointToDraw: CGFloat = 0.5
    private var numberOfArcsToBeDrawn = 0
    private var isMonochromBar = false
    var drawDot = false
    
    /// This holds the starting angle of the arc.
    private let arcStartAngleInDegrees: CGFloat = 157.5
    /// This holds the total area of the arc.
    private let totalArcArea: CGFloat = 225
    
    // CALayer Properties
    private let outerArclineWidth: CGFloat = 5
    private let animationDuration: Double = 1
    private var previousStartAngle: CGFloat = 0.0
    
    private var currentIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if !drawDot{
            configureView(with: 1.0, isMonoChrome: false)
        }
    }
    
    private func drawOutlineArc() {
        let layer = CAShapeLayer()
        layer.path = self.createRectangle(startAngle: CGFloat(157), endAngle: CGFloat(22))
        layer.lineWidth = outerArclineWidth
//        layer.strokeColor = UIColor.lightGray.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.name = "OutlineArc"
        self.layer.addSublayer(layer)
    }
    
    private func drawInnerArcTest() {
        let layer = CAShapeLayer()
        layer.path = self.createRectangle(startAngle: CGFloat(157.5), endAngle: CGFloat(22.5))
        layer.lineWidth = outerArclineWidth-2
        layer.strokeColor = UIColor.yellow.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.name = "InnerArcTest"
        self.layer.addSublayer(layer)
    }
    
    private func calculateNumberOfArcsRequiredAndDraw() {
        for (index, value) in data.enumerated() {
            if pointToDraw > value.startAngle {
                // Since the index is starting from 0, doing +1
                numberOfArcsToBeDrawn = index+1
            }
        }
        
        print("numberOfArcsToBeDrawn", numberOfArcsToBeDrawn)
        calculateDurationSlots()
        drawCircles()
    }
    
    private func calculateDurationSlots() {
        let percentage = animationDuration/Double(pointToDraw*100)
        for index in 0...numberOfArcsToBeDrawn-1 {
            if pointToDraw < data[index].endAngle && pointToDraw > data[index].startAngle {
                let difference = pointToDraw*100-data[index].startAngle*100
                let duration = Double(difference) * percentage
                data[index].duration = duration
            } else {
                let difference = data[index].endAngle*100 - data[index].startAngle*100
                let duration = Double(difference) * percentage
                data[index].duration = duration
            }
        }
    }
    
    func getLabel(frame:CGRect,text:String)->UILabel{
        let label = UILabel(frame: frame)
        label.font = UIFont.robotoRegular(size: 12)
        label.text = text
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8470588235)
        return label
    }

    
    private func drawCircles() {
        while currentIndex < numberOfArcsToBeDrawn {
            let layer = CAShapeLayer()
            let currentData = data[currentIndex]
            if currentIndex == numberOfArcsToBeDrawn-1 {
                layer.path = self.createRectangle(startAngle: getRadians(previousStartAngle), endAngle: getRadians(pointToDraw))
            } else {
                layer.path = self.createRectangle(startAngle: getRadians(previousStartAngle), endAngle: getRadians(currentData.endAngle))
            }
            previousStartAngle = data[currentIndex].endAngle
            layer.lineWidth = outerArclineWidth-2
            if isMonochromBar {
                layer.strokeColor = data[numberOfArcsToBeDrawn-1].color.cgColor
            } else {
                layer.strokeColor = currentData.color.cgColor
            }
            
            layer.fillColor = UIColor.clear.cgColor
            layer.name = "innerCircle\(currentIndex)"
            self.layer.addSublayer(layer)
            if currentData.color != .white {
                drawLabels(layer:layer)
            }

            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0.0
            animation.toValue = 0.5
            animation.duration = currentData.duration
            animation.delegate = self
            layer.add(animation, forKey: "end_\(currentIndex)")
            currentIndex = currentIndex + 1
            break
        }
    }
    
    func drawDot(value:CGFloat){
        self.drawDot = true
        if currentIndex == numberOfArcsToBeDrawn {
            let startAngle = getRadians(0).toRadians()
            let endAngle = getRadians(value).toRadians()
            
            let arcCenter = CGPoint(x: bounds.size.width / 2-1.5, y: bounds.size.height / 2)
            let circleRadius = bounds.size.width / 2
            let circlePath = UIBezierPath(arcCenter: arcCenter, radius: circleRadius, startAngle: startAngle, endAngle:endAngle, clockwise: true)
            
            // Make the view color transparent            
            let imageLayer = CAShapeLayer()
            imageLayer.backgroundColor = UIColor.clear.cgColor
            imageLayer.bounds = CGRect(x: self.frame.size.width/2, y: self.frame.size.height/2 , width: 28, height: 28)
            imageLayer.position = CGPoint(x:0, y: 0)
            imageLayer.contents = UIImage(named:"sliderDot")?.cgImage
            self.layer.addSublayer(imageLayer)
            
            let pathAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
            pathAnimation.duration = 1
            pathAnimation.path = circlePath.cgPath
            pathAnimation.repeatCount = 0
            pathAnimation.calculationMode = CAAnimationCalculationMode.paced
            pathAnimation.rotationMode = CAAnimationRotationMode.rotateAuto
            pathAnimation.fillMode = CAMediaTimingFillMode.forwards
            pathAnimation.isRemovedOnCompletion = false
            imageLayer.add(pathAnimation, forKey: "movingMeterTip") //need to refactor
        }
    }
    
    func drawLabels(layer:CAShapeLayer) {
        if let pathBounds = layer.path?.boundingBoxOfPath{
            print("currentIndex",currentIndex,pathBounds.origin.x,pathBounds.origin.y)
            var label = UILabel()
            if currentIndex == 0 {
//                let shapeFrame = CGRect(x: pathBounds.origin.x , y: pathBounds.origin.y + 150, width:
//                                            30, height: 20)
//
//                label = getLabel(frame: shapeFrame, text: "300")
                
//                label.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 3.5)
                
            } else if currentIndex == 2{
                let shapeFrame = CGRect(x: pathBounds.origin.x - 17, y: pathBounds.origin.y - 15, width:
                                            30, height: 20)
                
                label = getLabel(frame: shapeFrame, text: "500")
                
                label.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4.5)
                
            }else if currentIndex == 4 {
                let shapeFrame = CGRect(x: pathBounds.origin.x , y: pathBounds.origin.y - 25, width:
                                            30, height: 20)
                
                label = getLabel(frame: shapeFrame, text: "575")
                
                
            }else if currentIndex == 6 {
                let shapeFrame = CGRect(x: pathBounds.origin.x + 10 , y: pathBounds.origin.y - 20, width:
                                            30, height: 20)
                
                label = getLabel(frame: shapeFrame, text: "650")
                label.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 5)
                
            } else if currentIndex == 8 {
                let shapeFrame = CGRect(x: pathBounds.origin.x + 10 , y: pathBounds.origin.y - 5, width:
                                            30, height: 20)
                
                label = getLabel(frame: shapeFrame, text: "750")
                label.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.5)
                
//                let shapeFrame2 = CGRect(x: pathBounds.origin.x , y: pathBounds.origin.y + 125, width:
//                                            30, height: 20)
//
//                let label2 = getLabel(frame: shapeFrame2, text: "900")
//                self.addSubview(label2)
            }
            self.addSubview(label)
            
        }
    }
    
    private func getRadians(_ point: CGFloat) -> CGFloat {
        return (totalArcArea*point)+arcStartAngleInDegrees
    }
    
    public func configureView(with point: CGFloat, isMonoChrome: Bool) {
        self.layer.sublayers?.removeAll()
        resetViews()
        pointToDraw = point
        isMonochromBar = isMonoChrome
        drawOutlineArc()
        calculateNumberOfArcsRequiredAndDraw()
    }
    
    private func createRectangle(startAngle: CGFloat, endAngle: CGFloat) -> CGPath {
        // Initialize the path.
        return UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), radius: self.frame.size.height/2-(outerArclineWidth/2), startAngle: startAngle.toRadians(), endAngle: endAngle.toRadians(), clockwise: true).cgPath
    }
    
    private func resetViews() {
        pointToDraw = 0.5
        numberOfArcsToBeDrawn = 0
        isMonochromBar = false
        currentIndex = 0
        previousStartAngle = 0.0
    }
    
}

extension MonochromeView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        drawCircles()
    }
}
extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}
