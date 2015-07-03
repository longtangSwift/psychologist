//
//  TextViewController.swift
//  Psychologist
//
//  Created by CT MacBook Pro on 7/1/15.
//  Copyright © 2015 CT MacBook Pro. All rights reserved.
//

import UIKit

class TextViewController : UIViewController
{

    //when the outlet gets set, we are going to make the textView.text to be the text
    //here we dont' need the question mark becuase the textView is going to get set.
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.text = text
        }
    }
    
    var text: String = ""{
        didSet   {
            textView?.text = text
        }
    }
    //who knows about the best size of the popover? The textView controller does.  It is going to present the popover.  The textViewController is going to present this, so it should know the best size.  The preferred size is just a var named prefferedContentSize.  We can just set it by saying perferredContentSize equals something, but I think We best override it.  For, this is a subclass of UIViewController and as such, the ContentSize would change everytime the .text changes, or might change depending on how big of a popover space there is available to put a popover.  We just do better by overriding that var.
    override var preferredContentSize: CGSize{
        //if soemone tries ot get it and that the textView and if I am in the middle of being presented on screen (as indicated by the presentingViewController not being nil).  Then, we can actually ask a question to the textView and see what the preferred size is.  So, this computed property is clever.  If the textView has been set and if we are in the middle of being presented, we are going to return a value of the preferredContentSize that is preferred by the textView to show its text.  presentingViewController is that controller that is currently presenting you via some sort of seque
        get{
            if textView != nil && presentingViewController != nil {
                return textView.sizeThatFits(presentingViewController!.view.bounds.size)
            }else {return super.preferredContentSize}
        }
        //if something happens to set it, we will just let the original super class handle it.
        set{ super.preferredContentSize = newValue}
    }
}




