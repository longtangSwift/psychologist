//
//  DiagnosedHappinessViewController.swift
//  Psychologist
//
//  Created by CT MacBook Pro on 7/1/15.
//  Copyright © 2015 CT MacBook Pro. All rights reserved.
//

import UIKit
//this will allow us to be a UIPopoverPrestnCotrlerDeleate
class DiagnosedHappinessViewController : HappinessViewController, UIPopoverPresentationControllerDelegate
{
    override var happiness: Int{
        didSet {
            //diagnosticHistory += [happiness]
        }
    }
    override var tracker: Double{
        didSet{
            diagnosticHistory += [Double(happiness) + Double(RandX.random())]
        }
    }
    

    private let defaults = NSUserDefaults.standardUserDefaults() // we can save AnyObject into the defaults

    //an array of list of Ints is a property list, which is can be put in AnyOjbect in defults
    var diagnosticHistory: [Double] {
        get{return defaults.objectForKey(History.DefaultsKey) as? [Double] ?? []}
        set{defaults.setObject(newValue, forKey: History.DefaultsKey)}
    }

    private struct History{
        static let SegueIdentifier = "Show Diagnostic Hx"
        static let DefaultsKey = "DiagnosedHappinessController.History"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if let identifier = segue.identifier{
            switch identifier{
            case History.SegueIdentifier:
                if let tvc = segue.destinationViewController as? TextViewController {
                    //ppc is presentation popcontrol this if let will b nil if you are not currently being presented in a popover. So, if we decided to wrap this in a nav controler, it will return nil or if u go modal and not popover, it will b nil; we set the ppc.delegate so that the delegate gives control of the presentatioPopOverControler to someone els.
                    if let ppc = tvc.popoverPresentationController {
                        ppc.delegate = self
                    }
                    var tempTxt = ""
                    for i in diagnosticHistory{
                        var iTempTxt = ""
                        for ii in "\(i)".characters {
                            iTempTxt += "\(ii)"
                            //make the iTempTxt 6 characters long
                            if iTempTxt.characters.count > 5 {break}
                        }
                        tempTxt += "\(iTempTxt)   "
                    }
                    tvc.text = tempTxt
                }
            default: break
            }
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        //suspresses the modal mode on the Iphone. Otherwise the iphone goest modal.
        return UIModalPresentationStyle.None
    }
}