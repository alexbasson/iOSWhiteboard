import UIKit

extension UIViewController {
    func renderView(inNavController: Bool) {
        if let window = UIApplication.shared().keyWindow {
            if (inNavController) {
                let navController = UINavigationController(rootViewController: self)
                window.rootViewController = navController
            } else {
                window.rootViewController = self
            }
            RunLoop.main().run(until: Date())
        }
    }

    func renderView() {
        self.renderView(inNavController: false)
    }

    func renderViewInNavController() {
        self.renderView(inNavController: true)
    }
}
