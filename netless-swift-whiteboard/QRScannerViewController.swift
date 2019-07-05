import UIKit

protocol QRScannerViewControllerDelegate {
    func fireJoinRoom(uuid: String) -> Void
}

class QRScannerViewController: UIViewController, QRScannerViewDelegate {
    
    public var delegate: QRScannerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scanner = QRScannerView()
        scanner.delegate = self
        self.view.addSubview(scanner)
        scanner.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(self.view)
        })
        let border = UIView()
        self.view.addSubview(border)
        border.layer.borderColor = UIColor.yellow.cgColor
        border.layer.borderWidth = 1
        border.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 160, height: 160))
            make.center.equalTo(self.view)
        })
    }
    
    func qrScanningDidFail() {
        self.alertAndExit(text: "扫描失败")
    }
    
    func qrScanningDidStop() {}
    
    private func alertAndExit(text: String) {
        let alertController = UIAlertController(title: "错误",
                                                message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            self.navigationController?.popViewController(animated: true);
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        if str != nil {
            print("qrcode:", str!)
            self.navigationController?.popViewController(animated: true);
        } else {
            self.alertAndExit(text: "扫描失败")
        }
    }
}
