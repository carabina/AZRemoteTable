//
//  AZRemoteTableDataSource.swift
//  AZAutoTableView
//
//  Created by Antonio Zaitoun on 26/06/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit

public class AZRemoteTableDataSource: NSObject, UITableViewDataSource {

    fileprivate var showLoadingIndicator: Bool = false


    public func numberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        fatalError("Unimplemented Function")
    }

    public func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        fatalError("Unimplemented Function")
    }

    public func loadingCellFor(_ tableView: UITableView) -> UITableViewCell {
        let loadingIndicator = loadingView(tableView) ?? UIView()
        return LoadingCell(view: loadingIndicator, style: .default, reuseIdentifier: "loading_cell")
    }

    public final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoadingIndexPath(tableView, indexPath) {
            return loadingCellFor(tableView)
        }else {
            return cellForRowAt(tableView,indexPath: indexPath)
        }
    }

    public final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfItems = self.numberOfRowsInSection(tableView,section: section)
        return numberOfItems + ( showLoadingIndicator ? 1 : 0 )
    }


    /// Returns the view to display as the refresh control.
    ///
    /// - Parameter tableView: The tableview using this control.
    /// - Returns: UIRefreshControl to display. return nil to display no refresh control.
    public func refreshControl(_ tableView: UITableView) -> UIRefreshControl? {
        return UIRefreshControl()
    }


    /// Returns the view to display when loading initial data.
    ///
    /// - Parameter tableView: The tableview.
    /// - Returns: The view to display as the loading indicator.
    public func loadingView(_ tableView: UITableView) -> UIView? {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        return activityIndicator
    }


    /// Returns the view to display when an error occur.
    ///
    /// - Parameter tableView: The tableview.
    /// - Returns: A view to show the error, nil to show none.
    public func errorView(_ tableView: UITableView) -> UIView? {
        let errorLabel = UILabel()
        errorLabel.text = "Error"
        return errorLabel
    }

    /// A function called by the wrapper. never call this directly.
    ///
    /// - Parameter hasMore: a flag which indicates if there is more data to load.
    public final func notify(hasMore: Bool){
        showLoadingIndicator = hasMore
    }


    /// A function that checks if the current indexpath is a loading cell.
    ///
    /// - Parameters:
    ///   - tableView: The current table view.
    ///   - indexPath: The index path to check.
    /// - Returns: True if the index path belongs to a loading cell.
    internal func isLoadingIndexPath(_ tableView: UITableView,_ indexPath: IndexPath) -> Bool {
        guard showLoadingIndicator else { return false }
        return indexPath.row == self.tableView(tableView, numberOfRowsInSection: indexPath.section) - 1
    }
}

fileprivate class LoadingCell: UITableViewCell {

    convenience init(view: UIView, style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        isUserInteractionEnabled = false

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}