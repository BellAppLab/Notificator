import UIKit


class StatusBarViewController: UIViewController, Notificator {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    @IBAction func show(_ sender: UIButton) {
        let view = NotificatorView()
        view.dismissesWithTap = false
        view.notificator = self
        view.backgroundColor = UIColor.green
        self.notify(view: view,
                    expiringAfter: 1)
    }

    func didTapNotification(_ notificatorView: NotificatorView) {
        print("Did tap")
    }
}


class NoStatusBarViewController: UIViewController, Notificator {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func show(_ sender: UIButton) {
        let view = NotificatorView()
        view.dismissesWithTap = true
        view.notificator = self
        view.backgroundColor = UIColor.yellow
        self.notify(view: view)
    }
    
    func didTapNotification(_ notificatorView: NotificatorView) {
        print("Did tap")
    }
}

