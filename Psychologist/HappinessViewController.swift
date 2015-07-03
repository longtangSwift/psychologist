//
//  HappinessViewController.swift
//  Happinessƒs
//
//  ***This HappinessViewController conforms to the FaceViewDataSource protocol because it has a method called smilinessForFaceView that takes a sender: FaceView and returns a double.
//
//  Created by CT MacBook Pro on 6/28/15.
//  Copyright © 2015 CT MacBook Pro. All rights reserved.
//

import UIKit

//This HappinessViewController can call itself a FaceViewDataSource type because it conforms to that protocol because it has a method called silimnessForFaceView that takes a FaceView type parameter and returns a Double.
class HappinessViewController: UIViewController, FaceViewDataSource
{
    var RandX: LinearCongruentialGenerator = LinearCongruentialGenerator()
    //when this happiness is first set the property observer says to updateUI().  Well, we got here from preparation.  We are preparing for the segue and we tell the model to prepare and we set the happiness and it is supposed to prep the segue.  Well, the view is nothing yet and there is no faceView to draw.  When you are preparing, the outlet has for the faceView has not been set, so faceView is nil
        //there is a property observer here.  Anytime someone sets happy, we want the tittle of the HappinessViewConroller to update its title
    var happiness: Int = 22
        {                           //0 = very sad, 100 = happ
        didSet{
            happiness = min(max(happiness, 0), 100)
            print("happiness = \(happiness)")
            updateUI()
        }
    }
    var tracker: Double = 0 {
        didSet{}
    }
    
    //these put a crookedness to the smile and always is set with the happiness.
    var adjustY1: CGFloat = 10
    var adjustY2: CGFloat = 50
    //--HA! found it!  this datasSource var is a public weak var that resides in FaceView Class.  We can get to it here because faceView is a FaceView type.  IE it is a instance of FaceView.  FaceView Class has a public var named dataSource.  Look at it: we are saying faceView.dataSource = self.    Now that is weird. dataSource is of the type FaceViewDataSource
    //--the faceView is this outlet here.  How we got here is because someone was setting our model in var Happinesss
    @IBOutlet weak var faceView: FaceView! {
        //property observer
        didSet{
            faceView.dataSource = self //I think this is the delegate?? the dataSource is a public var
            faceView.addGestureRecognizer(UIPinchGestureRecognizer (target: faceView, action: "scale:")) //this selector nd b some non-private method in the FaceView
            //faceView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "changeHappiness:"))
            faceView.blahDataSource = self
            var adfa = faceView.blahDataSource
            adfa = self
            print(adfa)
            //--wow: you don't have to declare a variable.  You just call the .scheduledTimerWinterval method directly from NSTimer instance object which is already available to you.
            //NSTimer.scheduledTimerWithTimeInterval(45, target: self, selector: "interval", userInfo: nil, repeats: true)
        
            let formatter: NSNumberFormatter = NSNumberFormatter()
            if let _: Double? = formatter.numberFromString("234test")?.doubleValue{} // if you don't do if let, you will crash
            
            //--so in controller means the printing came from the HappinessViewController, but the RandX was in faceView, as evidenced by faceView.RandX.  Now let's make a HappinessViewController.RandX
            //print("in HV Controller \(Int(faceView.RandX.random() * 100))")
        }
    }
    
    
    
    private struct Constants{
        static let HappinessGesturScale: CGFloat = 4
    }
    
    @IBAction func changeHappiness(sender: AnyObject){
        let gest = sender as! UIPanGestureRecognizer
        switch gest.state{
        case .Ended: fallthrough
        case .Changed:
            let translation = gest.translationInView(faceView)
            let happinessChange = -Int(translation.y / Constants.HappinessGesturScale)
            if happinessChange != 0 {
                happiness += happinessChange
                gest.setTranslation(CGPointZero, inView: faceView)
            }
        default: break
        }
    }

    func updateUI()  //you must put it as an optional because when the thing first updates, the face view would be nil.  So, before the segue is called (ie in the prep phase, you don't need to draw faceView yet, so you can just put a ? there and ignore everything when the value is nil
    {
        //same sas if faceView != nil {faceView.setnddis} else {}  is the same as ??
        faceView?.setNeedsDisplay()
        title = "\(happiness)"
    }
    
    //-- This method 'smilinessForFaceView' is an interpreter for smiliness.  The user has a scale of 0 to 100, but the computer only knows -1 to 1.  So, this method in the Controller gives the information to the View through a delegate.  The View put out a protocol.  And the controller conforms to that protocol because it does have a method 'smilinessForFaceView that returns a double.  
    func smilinessForFaceView(sender: FaceView) -> (Double?, CGFloat?, CGFloat?) {
        print("in SmilinesForFaceView RandX= \(RandX.random())")
        return (Double (happiness - 50)/50, adjustY1, adjustY2)
    }
    func interval(){
        happiness += 1
        if happiness >= 100 {happiness = 0}
    }
}