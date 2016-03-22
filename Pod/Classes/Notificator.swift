import Foundation


@objc public protocol Notificator: AnyObject {
    func didTapNotification(notificatorView: NotificatorView)
}


public class NotificatorView: UIView
{
    @IBInspectable public var dismissesWithTap: Bool = true
    @IBOutlet public weak var notificator: Notificator?
    private weak var tap: UITapGestureRecognizer? {
        didSet {
            if let tap = oldValue {
                self.removeGestureRecognizer(tap)
            }
            if let newTap = tap {
                self.addGestureRecognizer(newTap)
            }
        }
    }
    private weak var swipe: UISwipeGestureRecognizer! {
        didSet {
            if let swipe = oldValue {
                self.removeGestureRecognizer(swipe)
            }
            if let newSwipe = swipe {
                self.addGestureRecognizer(newSwipe)
            }
        }
    }
    
    private var notificatorConstraints: [NSLayoutConstraint]!
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let superview = self.superview else { return }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.notificatorConstraints = []
        self.notificatorConstraints.append(NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: superview, attribute: .Top, multiplier: 1, constant: 0))
        self.notificatorConstraints.append(NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: superview, attribute: .Bottom, multiplier: 1, constant: 0))
        self.notificatorConstraints.append(NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: superview, attribute: .Left, multiplier: 1, constant: 0))
        self.notificatorConstraints.append(NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: superview, attribute: .Right, multiplier: 1, constant: 0))
        
        NSLayoutConstraint.activateConstraints(self.notificatorConstraints)
        
        self.tap = UITapGestureRecognizer(target: self, action: #selector(NotificatorView.handleGestures(_:)))
        self.swipe = UISwipeGestureRecognizer(target: self, action: #selector(NotificatorView.handleGestures(_:)))
        self.swipe.direction = .Up
    }
    
    public override func removeFromSuperview() {
        NSLayoutConstraint.deactivateConstraints(self.notificatorConstraints)
        
        self.tap = nil
        self.swipe = nil
        
        self.notificatorConstraints = nil
        
        super.removeFromSuperview()
    }
    
    @objc final func handleGestures(sender: UIGestureRecognizer) {
        if sender == self.tap {
            dispatch_async(dispatch_get_main_queue()) { [unowned self] () -> Void in
                self.notificator?.didTapNotification(self)
            }
            if !self.dismissesWithTap {
                return
            }
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            UIApplication.sharedApplication().dismissNotification()
        }
    }
}


public extension UIViewController
{
    public final var notifying: Bool {
        return UIApplication.notifying
    }
    
    public final func notify(view: NotificatorView, expiringAfter expiration: NSTimeInterval = 0) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            UIApplication.sharedApplication().notify(view, expiration)
        }
    }
    
    public final func dismissNotification() {
        if !self.notifying { return }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            UIApplication.sharedApplication().dismissNotification()
        }
    }
}
