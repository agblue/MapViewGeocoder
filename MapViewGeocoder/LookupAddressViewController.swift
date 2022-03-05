//
//  LookupAddressViewController.swift
//  PracticeApp
//
//  Created by Danny Tsang on 3/3/22.
//

import MapKit
import UIKit

class LookupAddressViewController: UIViewController, UITextFieldDelegate, MKLocalSearchCompleterDelegate, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    let searchRegion: MKCoordinateRegion?
    let searchCompleter = MKLocalSearchCompleter()
    var searchResults: [String] = []
    
    private lazy var closeButton: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonTapped))
        closeButton.accessibilityIdentifier = "LookUpAddressView.CloseButton"
        return closeButton
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityIdentifier = "LookUpAddressView.TextField"
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityIdentifier = "LookUpAddressView.TableView"
        return tableView
    }()
    
    // MARK: - View LifeCycle
    init(region: MKCoordinateRegion) {
        searchRegion = region
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Lookup Address"
        view.backgroundColor = UIColor.white
        
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchTextField.becomeFirstResponder()
    }
    
    func configureView() {
        navigationItem.leftBarButtonItem = closeButton
        
        view.addSubview(searchTextField)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50.0),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            
            tableView.topAnchor.constraint(equalTo:  searchTextField.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Did begin editing.")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        print("Search for: \(searchText)")
        performSearch(searchText)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    // MARK: - Search Method
    func performSearch(_ searchString: String) {
        guard let searchRegion = searchRegion else { return }
        
        searchCompleter.delegate = self
        searchCompleter.region = searchRegion
        searchCompleter.queryFragment = searchString
    }
    
    // MARK: - MKLocalSearchCompleter Delegate Method
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let addresses = completer.results.map { result in
            result.title + ", " + result.subtitle
        }
        print(addresses)
        searchResults = addresses
        tableView.reloadData()
    }
    
    
    // MARK: - UITableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
    
    
}
