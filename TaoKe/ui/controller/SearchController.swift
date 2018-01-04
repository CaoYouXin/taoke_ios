import FontAwesomeKit
import BTNavigationDropdownMenu
import PYSearch
import RxSwift

class SearchController: PYSearchViewController {
    
    private var menuView: BTNavigationDropdownMenu?
    private var resultViewHolder: SearchResultController?
    private var isJu = false
    
    var disposeBag = DisposeBag()
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
        searchBar.py_width = navigationController!.navigationBar.frame.size.width - menuView!.frame.size.width - 75
        searchBar.py_height = navigationController!.navigationBar.frame.size.height - 10
        searchTextField.frame = searchBar.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TaoKeApi.getTopHints()
            .rxSchedulerHelper()
            .handleApiError(self, nil)
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
                .handleApiError(self, nil)
                .subscribe(onNext: { (data) in
                self.searchSuggestions = data
            }).disposed(by: disposeBag)
        }
    }
    func searchViewController(_ searchViewController: PYSearchViewController!, didSelectSearchSuggestionAt indexPath: IndexPath!, searchBar: UISearchBar!) {
        resultViewHolder?.search(self.navigationController!, self.searchSuggestions[indexPath.row], isJu, self)
    }
}

