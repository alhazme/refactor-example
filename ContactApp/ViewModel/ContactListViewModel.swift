//
//  ContactListViewModel.swift
//  ContactApp
//
//  Created by Mochamad Fariz Al Hazmi on 06/11/19.
//  Copyright © 2019 Ridho Pratama. All rights reserved.
//

import Foundation
import UIKit

class ContactListViewModel: NSObject {
    
    // init from Protocol for unit testing
    private let service: ContactService
    
    // This data will show on ViewController
    private var rawContacts: [Contact] = []
    private var contactCellData: [ContactListCellData] = []
    
    // This callback function will run in ViewController
    // ViewModel -> ViewController
    var onError: ((Error) -> Void)?
    var onDataReceived: (() -> Void)?
    
    init(service: ContactService = NetworkContactService()) {
        self.service = service
    }
    
    // Called on ViewController
    func fetchContactList() {
        self.service.fetchContactList { [weak self] (result) in
            switch result {
                case let .success(contacts):
                    print(contacts)
                    self?.rawContacts = contacts
                    self?.contactCellData = contacts.map {
                        ContactListCellData(imageURL: $0.imageUrl, name: $0.name)
                    }
                    self?.onDataReceived?()
                case let .failure(error):
                    print(error)
                    self?.onError?(error)
            }
        }
    }
    
}

extension ContactListViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = contactCellData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactListTableViewCell.reuseIdentifier) as! ContactListTableViewCell
        cell.configureCell(with: cellData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
