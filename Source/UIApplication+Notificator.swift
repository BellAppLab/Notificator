import UIKit


internal extension UIApplication
{
    static var notifying: Bool {
        return self.shared
            
            .notificatorView != nil
    }
    
    private final var rootView: UIView? {
        guard let controller = self.keyWindow?.rootViewController else { return nil }
        if controller.isViewLoaded {
            return controller.view
        }
        return nil
    }
    
    private final var notificatorView: NotificatorContainerView? {
        guard let rootView = self.rootView else { return nil }
        for view in rootView.subviews {
            if let result = view as? NotificatorContainerView {
                return result
            }
        }
        return nil
    }
    
    final func notify(_ view: NotificatorView, _ expiration: TimeInterval)
    {
        guard let rootView = self.rootView else { return }
        
        func notifiyAgain(_ container: NotificatorContainerView) {
            container.addSubview(view)
            
            container.isOpaque = false
            container.alpha = 0.0
            container.isHidden = false
            rootView.addSubview(container)
            
            container.move(toInitialPosition: true)
            
            rootView.layoutIfNeeded()
            container.alpha = 1.0
            
            container.move(toInitialPosition: false)
            
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.6,
                           options: [.beginFromCurrentState, .allowUserInteraction, .layoutSubviews],
                           animations:
            {
                rootView.layoutIfNeeded()
            },
                           completion:
            { [unowned self] (finished: Bool) in
                if finished {
                    if expiration > 0 {
                        Timer.startNotificationTimer(self, expiration)
                    }
                }
            })
        }
        
        if let currentView = self.notificatorView {
            self.dismissNotification(false)
            notifiyAgain(currentView)
            return
        }
        notifiyAgain(NotificatorContainerView())
    }
    
    final func dismissNotification(_ animated: Bool = true) {
        guard let view = self.notificatorView, let rootView = self.rootView else { return }
        
        view.move(toInitialPosition: true)
        
        let animationBlock = {
            rootView.layoutIfNeeded()
        }
        let completionBlock = { (finished: Bool) in
            if finished {
                view.removeFromSuperview()
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.6,
                           options: [.beginFromCurrentState, .allowUserInteraction, .layoutSubviews],
                           animations: animationBlock,
                           completion: completionBlock)
            return
        }
        animationBlock()
        completionBlock(true)
    }
    
    @objc final func handleNotificatorTimer(_ sender: Timer)
    {
        Timer.stopNotificationTimer()
        self.dismissNotification()
    }
}


private class NotificatorContainerView: UIView {
    var initialConstraint: NSLayoutConstraint!
    var finalConstraint: NSLayoutConstraint!
    
    final func move(toInitialPosition initial: Bool) {
        if initial {
            self.initialConstraint.priority = UILayoutPriorityDefaultHigh
            self.finalConstraint.priority = UILayoutPriorityDefaultLow
        } else {
            self.initialConstraint.priority = UILayoutPriorityDefaultLow
            self.finalConstraint.priority = UILayoutPriorityDefaultHigh
        }
    }
    
    var xConstraint: NSLayoutConstraint!
    var compactWidthConstraint: NSLayoutConstraint!
    var regularWidthConstraint: NSLayoutConstraint!
    var largeHeightConstraint: NSLayoutConstraint!
    var smallHeightConstraint: NSLayoutConstraint!
    var normalHeightConstraint: NSLayoutConstraint!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let superview = self.superview else { return }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.initialConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
        self.initialConstraint.priority = UILayoutPriorityDefaultLow
        self.finalConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
        self.finalConstraint.priority = UILayoutPriorityDefaultLow
        self.xConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0)
        self.xConstraint.priority = UILayoutPriorityRequired
        
        self.compactWidthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 1, constant: 0)
        self.compactWidthConstraint.priority = UILayoutPriorityDefaultLow
        self.regularWidthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 414)
        self.regularWidthConstraint.priority = UILayoutPriorityDefaultLow
        self.largeHeightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64)
        self.largeHeightConstraint.priority = UILayoutPriorityDefaultLow
        self.smallHeightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36)
        self.smallHeightConstraint.priority = UILayoutPriorityDefaultLow
        self.normalHeightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
        self.normalHeightConstraint.priority = UILayoutPriorityDefaultLow
        
        self.traitCollectionDidChange(nil)
        
        NSLayoutConstraint.activate([self.initialConstraint, self.finalConstraint, self.xConstraint, self.compactWidthConstraint, self.regularWidthConstraint, self.largeHeightConstraint, self.smallHeightConstraint, self.normalHeightConstraint])
    }
    
    override func removeFromSuperview() {
        NSLayoutConstraint.deactivate([self.initialConstraint, self.finalConstraint, self.xConstraint, self.compactWidthConstraint, self.regularWidthConstraint, self.largeHeightConstraint, self.smallHeightConstraint, self.normalHeightConstraint])
        
        self.initialConstraint = nil
        self.finalConstraint = nil
        self.xConstraint = nil
        self.compactWidthConstraint = nil
        self.regularWidthConstraint = nil
        self.largeHeightConstraint = nil
        self.smallHeightConstraint = nil
        self.normalHeightConstraint = nil
        
        super.removeFromSuperview()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if let previous = previousTraitCollection {
            if previous.verticalSizeClass == self.traitCollection.verticalSizeClass && previous.horizontalSizeClass == self.traitCollection.horizontalSizeClass {
                return
            }
        }
        
        if self.traitCollection.verticalSizeClass == .regular && self.traitCollection.horizontalSizeClass == .regular { //iPad
            self.compactWidthConstraint?.priority = UILayoutPriorityDefaultLow
            self.regularWidthConstraint?.priority = UILayoutPriorityDefaultHigh
            if UIApplication.shared.isStatusBarHidden {
                self.largeHeightConstraint?.priority = UILayoutPriorityDefaultLow
                self.smallHeightConstraint?.priority = UILayoutPriorityDefaultLow
                self.normalHeightConstraint?.priority = UILayoutPriorityDefaultHigh
            } else {
                self.largeHeightConstraint?.priority = UILayoutPriorityDefaultHigh
                self.smallHeightConstraint?.priority = UILayoutPriorityDefaultLow
                self.normalHeightConstraint?.priority = UILayoutPriorityDefaultLow
            }
        } else {
            self.compactWidthConstraint?.priority = UILayoutPriorityDefaultHigh
            self.regularWidthConstraint?.priority = UILayoutPriorityDefaultLow
            if self.traitCollection.verticalSizeClass == .regular || self.traitCollection.horizontalSizeClass == .regular { //iPhone 6p
                if UIApplication.shared.isStatusBarHidden {
                    self.largeHeightConstraint?.priority = UILayoutPriorityDefaultLow
                    self.smallHeightConstraint?.priority = UILayoutPriorityDefaultLow
                    self.normalHeightConstraint?.priority = UILayoutPriorityDefaultHigh
                } else {
                    self.largeHeightConstraint?.priority = UILayoutPriorityDefaultHigh
                    self.smallHeightConstraint?.priority = UILayoutPriorityDefaultLow
                    self.normalHeightConstraint?.priority = UILayoutPriorityDefaultLow
                }
            } else { //Remaining iPhones
                if UIApplication.shared.isStatusBarHidden {
                    self.largeHeightConstraint?.priority = UILayoutPriorityDefaultLow
                    self.smallHeightConstraint?.priority = UILayoutPriorityDefaultHigh
                    self.normalHeightConstraint?.priority = UILayoutPriorityDefaultLow
                } else {
                    self.largeHeightConstraint?.priority = UILayoutPriorityDefaultHigh
                    self.smallHeightConstraint?.priority = UILayoutPriorityDefaultLow
                    self.normalHeightConstraint?.priority = UILayoutPriorityDefaultLow
                }
            }
        }
    }
}


private extension Timer
{
    static weak var forNotification: Timer?
    
    static func startNotificationTimer(_ application: UIApplication, _ time: TimeInterval) {
        self.stopNotificationTimer()
        
        self.forNotification = Timer.scheduledTimer(timeInterval: time,
                                                    target: application,
                                                    selector: #selector(UIApplication.handleNotificatorTimer(_:)),
                                                    userInfo: nil,
                                                    repeats: false)
    }
    
    static func stopNotificationTimer() {
        self.forNotification?.invalidate()
        self.forNotification = nil
    }
}
