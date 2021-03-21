//
//  TableViewController.swift
//
//  Copyright © 2017-2021 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public class TableViewController: UITableViewController
{
    public private(set) var editableCellIndex = 2

    private let allCellIdentifiers = ["SignInCell", "InfoCell", "EditCell", "NextCell"]
    private var currentCellIdentifiers: [String] = []

    @IBAction func toggleEditMode() {
        self.tableView.isEditing.toggle()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currentCellIdentifiers = self.allCellIdentifiers
        self.editableCellIndex = 2
        self.tableView.reloadData()
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentCellIdentifiers.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: currentCellIdentifiers[indexPath.row], for: indexPath)
    }

    public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.currentCellIdentifiers.count == self.allCellIdentifiers.count && indexPath.row == editableCellIndex
    }

    public override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        self.currentCellIdentifiers.remove(at: editableCellIndex)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    public override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return self.currentCellIdentifiers.count == self.allCellIdentifiers.count && indexPath.row == editableCellIndex
    }

    public override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let identifier = self.currentCellIdentifiers[sourceIndexPath.row]
        self.currentCellIdentifiers.remove(at: sourceIndexPath.row)
        self.currentCellIdentifiers.insert(identifier, at: destinationIndexPath.row)
        self.editableCellIndex = destinationIndexPath.row
    }
}
