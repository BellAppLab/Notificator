import UIKit


class ViewController: UIViewController, Notificator {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    
    @IBAction func show(sender: UIButton) {
        let view = NotificatorView()
        view.dismissesWithTap = false
        view.notificator = self
        view.backgroundColor = UIColor.greenColor()
        self.notify(view)
//        self.notify(view, expiringAfter: 1)
    }

    func didTapNotification(notificatorView: NotificatorView) {
        print("Did tap")
    }
}

