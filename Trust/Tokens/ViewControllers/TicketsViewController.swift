//
//  TicketsViewController.swift
//  Alpha-Wallet
//
//  Created by Oguzhan Gungor on 2/24/18.
//  Copyright © 2018 Alpha-Wallet. All rights reserved.
//

import Foundation
import UIKit
import StatefulViewController
import Result
import TrustKeystore

protocol TicketsViewControllerDelegate: class {
    func didPressRedeem(token: TokenObject, in viewController: UIViewController)
    func didPressSell(token: TokenObject, in viewController: UIViewController)
    func didPressTransfer(ticketHolder: TicketHolder?, token: TokenObject, in viewController: UIViewController)
}

class TicketsViewController: UIViewController {

    var viewModel: TicketsViewModel!
    var tokensStorage: TokensDataStore!
    var account: Wallet!
    var dataCoordinator: TransactionDataCoordinator!
    var session: WalletSession!
    weak var delegate: TicketsViewControllerDelegate?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.applyTintAdjustment()
    }

    @IBAction func didTapDoneButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func didPressRedeem(_ sender: UIButton) {
        delegate?.didPressRedeem(token: viewModel.token, in: self)
    }

    @IBAction func didPressSell(_ sender: UIButton) {
        delegate?.didPressSell(token: viewModel.token, in: self)
    }

    @IBAction func didPressTransfer(_ sender: UIButton) {
        delegate?.didPressTransfer(ticketHolder: nil, token: viewModel.token, in: self)
    }
}

extension TicketsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(for: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(for: tableView, indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.height(for: indexPath.section)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.ticketCellPressed(for: indexPath) {
            let ticketHolder = viewModel.item(for: indexPath)
            delegate?.didPressTransfer(ticketHolder: ticketHolder, token: viewModel.token, in: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
