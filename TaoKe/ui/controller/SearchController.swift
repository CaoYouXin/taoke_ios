import FontAwesomeKit
import BTNavigationDropdownMenu
import PYSearch
import RxSwift

class SearchController: PYSearchViewController {
    
    private var menuView: BTNavigationDropdownMenu?
    private var resultViewHolder: SearchResultController?
    private var isJu = false
    
    private let disposeBag = DisposeBag()
    var shouldBeginEditingFlag: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        delegate = self
        
        searchResultShowMode = .embed
        resultViewHolder = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "SearchResultController") as? SearchResultController
        searchResultController = resultViewHolder
        
        searchBar.delegate = self
        cancelButton.customView = menuView
    }
    
    override func viewDidLayoutSubviews() {
        searchBar.py_origin = CGPoint(x: 0, y: 0)
        searchBar.py_size = CGSize(width: navigationController!.navigationBar.frame.size.width - menuView!.frame.size.width - navigationController!.navigationBar.frame.size.height * 2,
                                   height: navigationController!.navigationBar.frame.size.height - 10)
        
        if #available(iOS 11, *) {
            // ignore
        } else {
            searchBar.frame = CGRect(x: searchBar.bounds.minX - searchBar.bounds.width / 2 - navigationController!.navigationBar.frame.size.height * 0.382,
                                      y: searchBar.bounds.minY - searchBar.bounds.height / 2,
                                      width: searchBar.bounds.width,
                                      height: searchBar.bounds.height)
        }
        
        searchTextField.frame = searchBar.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        
        TaoKeApi.getTopHints()
            .rxSchedulerHelper()
            .handleApiError(self)
            .subscribe(onNext: { (data) in
            self.hotSearches = data
        }).disposed(by: disposeBag)
        
        let menuItems = ["好券", "聚划算"]
        let menuView = BTNavigationDropdownMenu(title: BTTitle.index(0), items: menuItems)
        menuView.menuTitleColor = UIColor("#424242")
        menuView.navigationBarTitleFont = UIFont.systemFont(ofSize: 15)
        menuView.arrowTintColor = UIColor("#424242")
        
        menuView.cellBackgroundColor = UIColor("#ffb74d")
        menuView.cellSeparatorColor = .white
        menuView.cellSelectionColor = UIColor("#ffa726")
        menuView.cellTextLabelColor = UIColor("#424242")
        menuView.cellTextLabelFont = UIFont.systemFont(ofSize: 15)
        
        menuView.didSelectItemAtIndexHandler = { (indexPath: Int) -> () in
            self.isJu = indexPath == 1
        }
        self.menuView = menuView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SearchController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if !shouldBeginEditingFlag {
            shouldBeginEditingFlag = true
            return false
        }
        return true
    }
}

extension SearchController: PYSearchViewControllerDelegate {
    func searchViewController(_ searchViewController: PYSearchViewController!, didSelectHotSearchAt index: Int, searchText: String!) {
        resultViewHolder?.search(self.navigationController!, searchText, isJu, self)
    }
    
    func searchViewController(_ searchViewController: PYSearchViewController!, didSelectSearchHistoryAt index: Int, searchText: String!) {
        resultViewHolder?.search(self.navigationController!, searchText, isJu, self)
    }
    func searchViewController(_ searchViewController: PYSearchViewController!, didSearchWith searchBar: UISearchBar!, searchText: String!) {
        resultViewHolder?.search(self.navigationController!, searchText, isJu, self)
    }
    func searchViewController(_ searchViewController: PYSearchViewController!, searchTextDidChange searchBar: UISearchBar!, searchText: String!) {
        if searchText.elementsEqual("") {
            self.searchSuggestions = []
        } else {
            TaoKeApi.getSearchHint(searchText)
                .rxSchedulerHelper()
                .handleApiError(self)
                .subscribe(onNext: { (data) in
                self.searchSuggestions = data
            }).disposed(by: disposeBag)
        }
    }
    func searchViewController(_ searchViewController: PYSearchViewController!, didSelectSearchSuggestionAt indexPath: IndexPath!, searchBar: UISearchBar!) {
        resultViewHolder?.search(self.navigationController!, self.searchSuggestions[indexPath.row], isJu, self)
    }
}

