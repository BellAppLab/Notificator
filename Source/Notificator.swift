import UIKit


@objc public protocol Notificator: AnyObject {
    func didTapNotification(_ notificatorView: NotificatorView)
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
        self.notificatorConstraints.append(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0))
        self.notificatorConstraints.append(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0))
        self.notificatorConstraints.append(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1, constant: 0))
        self.notificatorConstraints.append(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1, constant: 0))
        
        NSLayoutConstraint.activate(self.notificatorConstraints)
        
        self.tap = UITapGestureRecognizer(target: self, action: #selector(NotificatorView.handleGestures(_:)))
        self.swipe = UISwipeGestureRecognizer(target: self, action: #selector(NotificatorView.handleGestures(_:)))
        self.swipe.direction = .up
    }
    
    public override func removeFromSuperview() {
        NSLayoutConstraint.deactivate(self.notificatorConstraints)
        
        self.tap = nil
        self.swipe = nil
        
        self.notificatorConstraints = nil
        
        super.removeFromSuperview()
    }
    
    @objc final func handleGestures(_ sender: UIGestureRecognizer) {
        if sender == self.tap {
            DispatchQueue.main.async { [unowned self] () -> Void in
                self.notificator?.didTapNotification(self)
            }
            if !self.dismissesWithTap {
                return
            }
        }
        DispatchQueue.main.async { () -> Void in
            UIApplication.shared.dismissNotification()
        }
    }
}


public extension UIViewController
{
    public final var notifying: Bool {
        return UIApplication.notifying
    }
    
    public final func notify(view: NotificatorView, expiringAfter expiration: TimeInterval = 0) {
        DispatchQueue.main.async { () -> Void in
            UIApplication.shared.notify(view, expiration)
        }
    }
    
    public final func dismissNotification() {
        if !self.notifying { return }
        DispatchQueue.main.async { () -> Void in
            UIApplication.shared.dismissNotification()
        }
    }
}
