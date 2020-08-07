import UIKit

protocol SelectCountryViewControllerDelegate: class {
    func selectCountryViewController(_ viewController: SelectCountryViewController, didSelectCountry country: Country)
}

class SelectCountryViewController: BaseViewController {

	var tableView: UITableView = {
		let table = UITableView.init(frame: CGRect.zero, style: .insetGrouped)
		table.separatorStyle = .none
		table.register(UINib.init(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: ReuseId.cell)
        table.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
		table.tintColor = R.color.mainRed()
		return table
	}()
    
    typealias Section = [Country]
    
    enum SectionIndex {
        static let currentSelected = 0
    }
    
    enum ReuseId {
        static let cell = "country_cell"
        static let header = "country_header"
    }
    
    var selectedCountry = CountryCodeLibrary.shared.deviceCountry
    weak var delegate: SelectCountryViewControllerDelegate?

    private let sectionHeaderHeight: CGFloat = 10
    private var sections = [Section]()
    private var sectionIndexTitles = [String]()
	
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Region"
        let countries = CountryCodeLibrary.shared.countries
        let selector = #selector(getter: Country.localizedName)
        (sectionIndexTitles, sections) = UILocalizedIndexedCollation.current().catalogue(countries, usingSelector: selector)
        tableView.delegate = self
        tableView.dataSource = self
		self.view.addSubview(self.tableView)
		self.tableView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
    }
}

extension SelectCountryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 1 {
			return 1
		} else {
			return sections[section - 1].count
		}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseId.cell)! as! CountryCell
        let country: Country
		if indexPath.section == SectionIndex.currentSelected {
			country = CountryCodeLibrary.shared.deviceCountry
		} else {
			country = sections[indexPath.section - 1][indexPath.row]
		}
        cell.flagImageView.image = UIImage(named: country.isoRegionCode.lowercased())
        cell.nameLabel.text = country.localizedName
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count + 1
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        sectionIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index + 1
    }
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}

}

extension SelectCountryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        sectionHeaderHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
			delegate?.selectCountryViewController(self, didSelectCountry: CountryCodeLibrary.shared.deviceCountry)
		} else {
			delegate?.selectCountryViewController(self, didSelectCountry: sections[indexPath.section - 1][indexPath.row])
		}
    }

}

