import UIKit
import FontAwesomeKit
import RxSwift

class ReportController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var reportText: UITextView!
    
    private let reportHint = "反馈内容"
    
    var disposeBag = DisposeBag()
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text.elementsEqual(reportHint) {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        return true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.count < 1 {
            textView.text = reportHint
            textView.textColor = UIColor.gray
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "反馈"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.plain, target: self, action: #selector(report))
        
        reportText.delegate = self
        reportText.text = reportHint
        reportText.textColor = UIColor.gray
        
        reportText.layer.borderWidth = 1
        reportText.layer.borderColor = UIColor("#EED533").cgColor
        reportText.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func report() {
        if let input = reportText.text {
            TaoKeApi.report(input).rxSchedulerHelper()
                .handleApiError(self, { _ in
                    self.navigationController?.popViewController(animated: true)
                }).subscribe(onNext: { _ in
                    self.navigationController?.popViewController(animated: true)
                }).disposed(by: disposeBag)
        }
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
