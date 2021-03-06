// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

public class RFAttributedTextFormItem: RFFormItem {
    override func accept(visitor: RFFormItemVisitor) {
		visitor.visit(object: self)
    }

	public var title: NSAttributedString?

	@discardableResult
	public func title(_ title: NSAttributedString) -> Self {
		self.title = title
		return self
	}

	@discardableResult
	public func title(_ title: String, _ attributes: [String: AnyObject]? = nil) -> Self {
		#if swift(>=4.0)
			if let attributes = attributes {
				let newAttributes = Dictionary(uniqueKeysWithValues: attributes.map { key, value in (NSAttributedString.Key(key), value) })
				self.title = NSAttributedString(string: title, attributes: newAttributes)
			} else {
				self.title = NSAttributedString(string: title, attributes: nil)
			}
		#else
			self.title = NSAttributedString(string: title, attributes: attributes)
		#endif
		return self
	}

	typealias SyncBlock = (_ value: NSAttributedString?) -> Void
	var syncCellWithValue: SyncBlock = { (value: NSAttributedString?) in
		RFLog("sync is not overridden")
	}

	internal var innerValue: NSAttributedString?
	public var value: NSAttributedString? {
		get {
			return self.innerValue
		}
		set {
			innerValue = newValue
			syncCellWithValue(innerValue)
		}
	}

	@discardableResult
	public func value(_ value: NSAttributedString) -> Self {
		self.value = value
		return self
	}

	@discardableResult
	public func value(_ value: String, _ attributes: [String: AnyObject]? = nil) -> Self {
		#if swift(>=4.0)
			if let attributes = attributes {
				let newAttributes = Dictionary(uniqueKeysWithValues: attributes.map { key, value in (NSAttributedString.Key(key), value) })
				self.value = NSAttributedString(string: value, attributes: newAttributes)
			} else {
				self.value = NSAttributedString(string: value, attributes: nil)
			}
		#else
			self.value = NSAttributedString(string: value, attributes: attributes)
		#endif
		return self
	}
}

@available(*, unavailable, renamed: "RFAttributedTextFormItem")
typealias AttributedTextFormItem = RFAttributedTextFormItem
