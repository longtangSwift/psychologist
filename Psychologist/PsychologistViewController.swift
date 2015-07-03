//
//  ViewController.swift
//  Psychologist
//
//  Created by CT MacBook Pro on 6/30/15.
//  Copyright © 2015 CT MacBook Pro. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController {

    weak var adfafd: FaceViewDataSource? //this is nothing. Testin w/ fx below

    @IBAction func forgot(sender: UIButton) {
        performSegueWithIdentifier("forgot", sender: self)
    }
    
    @IBAction func testtest(sender: UIButton) {
        performSegueWithIdentifier("testtest", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination: UIViewController?
        destination = segue.destinationViewController
        //the top layer will be used and things end here.  The next if won't be true b/c the destination is not a HappinessViewController.
        if let navCon = destination as? UINavigationController{
            destination = navCon.visibleViewController
        }
        
        //the oringinal if let hvc = segue.destinationViewController as? HappinessViewController   will not work now because we are embeded the navigation controller.
        

        //if the seque is not going to the faceView, the if let will not go
        if let hvc = destination as? HappinessViewController {
            if let identifier = segue.identifier{
                switch identifier{
                case "show sad": hvc.happiness = 0; hvc.adjustY1 = 10; hvc.adjustY2 = 50; hvc.tracker = 0
                case "show happy": hvc.happiness = 75; hvc.adjustY1 = 10; hvc.adjustY2 = 50; hvc.tracker = 0
                case "show super happy": hvc.happiness = 100; hvc.adjustY1 = 10; hvc.adjustY2 = 50; hvc.tracker = 0
                case "nothing": hvc.happiness = 25; hvc.adjustY1 = 320; hvc.adjustY2 = 151.9; hvc.tracker = 0
                case "forgot": hvc.happiness = 36; hvc.adjustY1 = 151.9; hvc.adjustY2 = 233.33; hvc.tracker = 0
                case "show flat": hvc.happiness = 56; hvc.adjustY1 = 33; hvc.adjustY2 = 0; hvc.tracker = 0
                default: hvc.happiness = 43; hvc.adjustY1 = 9999; hvc.adjustY2 = 555.5; hvc.tracker = 0
                }
            }
        }
    }
}

