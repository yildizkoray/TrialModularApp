//
//  ProductsViewController.swift
//  ProductListing
//
//  Created by Koray Yıldız on 16.09.22.
//

import UIKit
import SnapKit
import Checkout

protocol ProductsViewDelegate: AnyObject {
    func reloadData()
    func setCheckoutButtonTitle(text: String)
    func configureSectionHeaderPriceLabel(at indexPath: IndexPath, with text: String)
}

public final class ProductsViewController: UIViewController {

    var viewModel: ProductsViewModel!

    private lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()

    private lazy var checkoutButton: UIButton = {
        var button = UIButton()
        button.setTitle("Checkout (0)", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .gray.withAlphaComponent(0.3)
        button.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        return button
    }()

    @objc private func checkoutButtonTapped() {
        let view = CheckoutViewController()
        navigationController?.present(view, animated: true)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureContainerView()
        configureTableView()
        addSubviews()

        title = "Products"

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalTo(view)
            make.leading.equalTo(view)
            make.bottom.equalTo(checkoutButton.snp.top)
        }

        checkoutButton.snp.makeConstraints { make in
            make.trailing.equalTo(view)
            make.leading.equalTo(view)
            make.height.equalTo(44)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        viewModel = ProductsViewModel(viewDelegate: self, service: .init(backend: .init()))
        viewModel.fetchProducts()
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.identifier)
        tableView.register(ProductsCategoryHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: ProductsCategoryHeaderView.identifier)
    }

    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(checkoutButton)
    }

    private func configureContainerView() {
        view.backgroundColor = .white
    }
}

// MARK: - UITableViewDataSource
extension ProductsViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.presentation.productList.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.presentation.productList[section].products.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier,
                                                       for: indexPath) as? ProductCell else {
            return ProductCell(style: .default, reuseIdentifier: ProductCell.identifier)
        }

        let product = viewModel.presentation.productList[indexPath.section].products[indexPath.row]
        let cellViewModel = ProductCellViewModel(
            viewDelegate: cell,
            presentation: product,
            delegate: viewModel.cellDelegate
        )

        cell.viewModel = cellViewModel
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductsViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header =
                tableView.dequeueReusableHeaderFooterView(withIdentifier: ProductsCategoryHeaderView.identifier)
                as? ProductsCategoryHeaderView else {
            return ProductsCategoryHeaderView()
        }
        header.configure(with: viewModel.presentation.productList[section].category)
        return header
    }
}

// MARK: - ProductsViewDelegate
extension ProductsViewController: ProductsViewDelegate {
    func reloadData() {
        tableView.reloadData()
    }
    
    func setCheckoutButtonTitle(text: String) {
        checkoutButton.setTitle(text, for: .normal)
    }

    func configureSectionHeaderPriceLabel(at indexPath: IndexPath, with text: String) {
        if let header = tableView.headerView(forSection: indexPath.section) as? ProductsCategoryHeaderView {
            header.configurePriceLabel(with: text)
        }
    }
}
