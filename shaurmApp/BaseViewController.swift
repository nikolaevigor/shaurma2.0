

import UIKit

class BaseViewController: UIViewController, SlideMenuDelegate {
    
    var sideMenuWidth = UIScreen.mainScreen().bounds.size.width/2
    var toggleOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
            print("Home\n", terminator: "")
            break
        case 1:
            print("Play\n", terminator: "")
            break
        case 2:
            print("Camera\n", terminator: "")
            break
        default:
            print("default\n", terminator: "")
            break
        }
        self.swipeLeft()
    }
    
    func addSlideMenuButton(){
        
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: "swipeRight")
        rightSwipe.direction = .Right
        view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
        leftSwipe.direction = .Left
        view.addGestureRecognizer(leftSwipe)
        
        
        let btnShowMenu = UIButton(type: UIButtonType.System)
        btnShowMenu.setImage(self.defaultMenuImage(), forState: UIControlState.Normal)
        btnShowMenu.frame = CGRectMake(0, 0, 30, 30)
        btnShowMenu.addTarget(self, action: "onSlideMenuButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken, { () -> Void in
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 22), false, 0.0)
            
            UIColor.blackColor().setFill()
            UIBezierPath(rect: CGRectMake(0, 3, 30, 1)).fill()
            UIBezierPath(rect: CGRectMake(0, 10, 30, 1)).fill()
            UIBezierPath(rect: CGRectMake(0, 17, 30, 1)).fill()
            
            UIColor.whiteColor().setFill()
            UIBezierPath(rect: CGRectMake(0, 4, 30, 1)).fill()
            UIBezierPath(rect: CGRectMake(0, 11,  30, 1)).fill()
            UIBezierPath(rect: CGRectMake(0, 18, 30, 1)).fill()
            
            defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
        })
        
        return defaultMenuImage;
    }
    
    
    func swipeLeft(){
        if self.toggleOn == true {
            self.toggleOn = false
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * self.sideMenuWidth
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clearColor()
                }, completion: { (finished) -> Void in
                    viewMenuBack.removeFromSuperview()
            })
        }
    }
    
    func swipeRight(){
        if self.toggleOn == false {
            self.toggleOn = true
            let menuVC : MenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
            
            menuVC.view.frame=CGRectMake(0 - self.sideMenuWidth, 0, self.sideMenuWidth, UIScreen.mainScreen().bounds.size.height);

            menuVC.delegate = self
            self.view.addSubview(menuVC.view)
            self.addChildViewController(menuVC)
            menuVC.view.layoutIfNeeded()
            
            
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                menuVC.view.frame=CGRectMake(0, 0, self.sideMenuWidth, UIScreen.mainScreen().bounds.size.height);
                }, completion:nil)
        }
    }
    
    func onSlideMenuButtonPressed(sender : UIButton){
        if self.toggleOn == false {
            self.swipeRight()
            self.toggleOn = true
        }
        else{
            self.swipeLeft()
            self.toggleOn = false
        }
        
//        if (sender.tag == 10)
//        {
//            self.slideMenuItemSelectedAtIndex(-1);
//            
//            sender.tag = 0;
//            
//            let viewMenuBack : UIView = view.subviews.last!
//            
//            UIView.animateWithDuration(0.3, animations: { () -> Void in
//                var frameMenu : CGRect = viewMenuBack.frame
//                frameMenu.origin.x = -1 * UIScreen.mainScreen().bounds.size.width
//                viewMenuBack.frame = frameMenu
//                viewMenuBack.layoutIfNeeded()
//                viewMenuBack.backgroundColor = UIColor.clearColor()
//                }, completion: { (finished) -> Void in
//                    viewMenuBack.removeFromSuperview()
//            })
//            
//            return
//        }
//        
//        sender.enabled = false
//        sender.tag = 10
//        
//        let menuVC : MenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
//        menuVC.btnMenu = sender
//        
//        menuVC.delegate = self
//        self.view.addSubview(menuVC.view)
//        self.addChildViewController(menuVC)
//        menuVC.view.layoutIfNeeded()
//        
//        
//        menuVC.view.frame=CGRectMake(0 - UIScreen.mainScreen().bounds.size.width, 0, UIScreen.mainScreen().bounds.size.width/3, UIScreen.mainScreen().bounds.size.height);
//        
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            menuVC.view.frame=CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height);
//            sender.enabled = true
//            }, completion:nil)
    }
}