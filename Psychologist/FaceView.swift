//
//  FaceView.swift
//  Happiness
//
//  Created by CT MacBook Pro on 6/28/15.
//  Copyright © 2015 CT MacBook Pro. All rights reserved.
//

import UIKit
//I think FaceView is a model? I am not sure. I know that the model owns its own data.  This does not seem to.  It seems to need a delegate to get the data, so it is a view, then.  This is a view.  So, where is the model?
//usually we name these protocols as delegates, but because we are just getting DataSource, we just name it that.  Also, this protocol can only be implemented by class and not structs or enums because we need the memory to be weak.
protocol FaceViewDataSource: class
{
    func smilinessForFaceView(sender: FaceView) -> (Double?, CGFloat?, CGFloat?)
}
 
@IBDesignable
class FaceView: UIView
{

    @IBInspectable
    var lineWid: CGFloat = 3 {didSet {setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }
    @IBInspectable
    var scale: CGFloat = (0.91 ){ didSet {setNeedsDisplay() } }

    
    //--This RandX of type RandomNumberGenerator (you can make it that type because LinearConGen conforms to the requirements of that protocol is accessible now in the HappinessViewController because we made a delegate over there.  It is amazing that I can call this RandX instance object from there.
    let RandX: LinearCongruentialGenerator = LinearCongruentialGenerator()
    //---
    
    var faceCenter: CGPoint{ return convertPoint(center, fromView: superview)}
    var faceRadius: CGFloat{ return min(bounds.size.width, bounds.size.height) / 2 * scale}
    
    //-- we need a public var that is of the type FaceViewDataSource. So, who ever wants to provide the data for this view, all they need to do is to set themselves to be this FaceViewDataSource type.  ie:  let x = faceView.dataSource. And we can talk through this variable.  This talk will take place via the method smilinessForFaceView in the protocol.  We need it to be weak, because the controller will set itself as the dataSource, so it is going to set its pointer back to itself because our controller is going to be a FaceViewDataSource type.  And the controller also has a pointer to this FaceView through the view hierarchy So, there is all this back and forth pointing.  The view's delegate is the controller which points to this FaceViewDataSource protocol. And the controller also points to FaceView via the hierarchy.  So, by making it weak, it allows the controller to go out of memory.
    
    weak var dataSource: FaceViewDataSource?
    weak var blahDataSource: FaceViewDataSource?
    
    //--
    
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 13
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 2.5699
    }
    
    private enum Eye { case Left, Right }
    
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath
    {
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        
        switch whichEye{
        case .Left: eyeCenter.x -= eyeHorizontalSeparation / 2
        case .Right: eyeCenter.x += eyeHorizontalSeparation / 2
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWid
        return path
    }
    
    private func bezierPathForSmile(fractionOfMaxSmile: Double) -> UIBezierPath
    {
        
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let y: CGFloat = start.y + smileHeight
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: y + 10 * CGFloat(-fractionOfMaxSmile))
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: y + 51 * CGFloat(fractionOfMaxSmile) )
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWid
        return path
    }

    private func bezierPathForSmile(fractionOfMaxSmile: Double, adjustY1: CGFloat, adjustY2: CGFloat) -> UIBezierPath
    {
        
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let y: CGFloat = start.y + smileHeight
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: y + adjustY1 * CGFloat(-fractionOfMaxSmile))
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: y + adjustY2 * CGFloat(fractionOfMaxSmile) )
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWid
        return path
    }

    
    
    override func drawRect(rect: CGRect)
    {
       let facePath = UIBezierPath(
        arcCenter: faceCenter,
        radius: faceRadius,
        startAngle: 0,
        endAngle: CGFloat(2*M_PI),
        clockwise: true
        )
        
        facePath.lineWidth = lineWid
        color = UIColor.blueColor()
        color.setStroke()
        color = UIColor.yellowColor()
        color.setFill()
        facePath.fill()
        facePath.stroke()
        
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()

        // MARK---- **** Woh! look here:  we have a dataSource?.smilinessForFaceView(self) thing going on here.  So, we are sending self to this method.  The dataSource is a public var.  (weak var) that is declared here in this FaceView.  It is of the type FaceViewDataSource which is also the protocol that we made outside of this currect class FaceView.  So, we know that dataSource is of the FaceViewDataSource type, meaning it has a method called 'smilinessForFaceView' that takes a FaceView type object and returns a Double.  To send self to this method means that self is a FaceView type.
        
        let delegateInfo = dataSource?.smilinessForFaceView(self) ?? (0.092939234897234, 15, 80) // if the value on the left is nil, use right //and the role of the 'smilinessForFaceView' method is simply to interpret 75 as .25
        let adjustY1 = delegateInfo.1  //puts a crookedness to things.
        let adjustY2 = delegateInfo.2
        print("Smilininess is \(delegateInfo.0) adjustY1 is \(adjustY1)  ajdustY2 is \(adjustY2)")
        let smilePath = bezierPathForSmile(delegateInfo.0!, adjustY1: CGFloat(adjustY1!), adjustY2: CGFloat(adjustY2!))
        smilePath.stroke()
        
        //--so it looks like by making a public var of blahDataSource of the FaceViewDataSourceDelegate type, we can access .smilinessForFaceView even though that method does not exist in the FaceView class.  That method resides in HappinessViewController.  This is exactly why the HappinessViewController has that method, and is why we consider HappinessViewController to conform to the FaceViewDataSource protocol
        //I tested this: you pass self to the .smilinessForFaceView method.  The self is a FaceView. [This also explains the line in HappinessViewControl that says faceView.dataSource = self .  That is the way that faceView.dataSource is of type FaceView.  We declared dataSource to be a public weak var dataSource: DataSourceFaceView?.  So, now The method returns a Double? that is the smiliness, after you passed self to it:
        let blahTestIgnore = blahDataSource?.smilinessForFaceView(self)
        //let blahblahTestIgnor = blahDataSource?.smilinessForFaceView(self) 
                if blahTestIgnore != nil {print ("blahTestIgnor is \(blahTestIgnore)")}
        
    }
    
    func scale(gesture: UIPinchGestureRecognizer){
        //I am only going to adjust the scale when I move.  When it first goes done, it is scale of 1.
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1 //we keep on moving it to 1 so that it just measures movement.  The last movement.
        }
    }

}
