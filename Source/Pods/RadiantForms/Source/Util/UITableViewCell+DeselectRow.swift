// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

extension UITableViewCell {
	/**
	Deselect the current cell
	
	This is a work around.
	
	PROBLEM: This function is sadly unreliable.
	`UITableView.deselectRowAtIndexPath(indexPath, animated: true)`
	I'm experiencing problems near the bottom of the tableview.
	when I insert/remove cells with animation and deselect, then the cell stays selected.
	And the UITableView.indexPathsForSelectedRows thinks that the cell is not selected.
	
	PROBLEM: This function is sadly unreliable.
	`UITableViewCell.setSelected(false, animated: true)`
	This works on iPhone, but not on iPad where the row stays selected.

	The indexPath of the cell may change during animation because rows are inserted/removed.
	Most insert/remove animations are shorter than half a second.
	Thus I attempt to deselect again after 500ms.
	*/
	func rf_deselectRow() {
		rf_deselectIfNeeded()

		let delay = DispatchTime.now() + Double(Int64(0.5 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		DispatchQueue.main.asyncAfter(deadline: delay) {
			self.rf_deselectIfNeeded()
		}
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_deselectRow instead")
    func form_deselectRow() {
        return rf_deselectRow()
    }

	fileprivate func rf_deselectIfNeeded() {
		if isSelected == false {
			//print("already deselected, no need to deselect")
			return
		}
		guard let tableView = rf_tableView() as? RFFormTableView else {
			return
		}
		guard let sectionArray = tableView.dataSource as? RFTableViewSectionArray else {
			return
		}
		guard let item = sectionArray.findItem(self) else {
			return
		}
		guard let indexPath = sectionArray.indexPathForItem(item) else {
			return
		}
		//print("deselecting: \(indexPath)   selectedRows \(tableView.indexPathsForSelectedRows)")

		tableView.deselectRow(at: indexPath, animated: true)
		setSelected(false, animated: true)
	}
}
