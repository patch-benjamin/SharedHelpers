/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import Foundation

public extension NSMutableAttributedString {
    
    public func increaseFontSize(by multiplier: CGFloat) {
        enumerateAttribute(NSAttributedStringKey.font, in: NSMakeRange(0, length), options: []) { (font, range, stop) in
            guard let font = font as? UIFont else { return }
            let newFont = font.withSize(font.pointSize * multiplier)
            removeAttribute(NSAttributedStringKey.font, range: range)
            addAttribute(NSAttributedStringKey.font, value: newFont, range: range)
        }
    }
    
    public func highlightStrings(_ stringToHighlight: String?, color: UIColor) {
        let textMatches = string.matches(for: stringToHighlight)
        for match in textMatches {
            addAttribute(NSAttributedStringKey.backgroundColor, value: color, range: match.range)
        }
    }
    
    public func highlightMatches(with ranges: [CountableClosedRange<Int>], color: UIColor) {
        ranges.map(Range.init).map(NSRange.init).forEach {
            addAttribute(NSAttributedStringKey.backgroundColor, value: color, range: $0)
        }
    }
    
}



public extension String {
    
    func matches(for stringToHighlight: String?) -> [NSTextCheckingResult] {
        guard let stringToHighlight = stringToHighlight, !stringToHighlight.isEmpty else { return [] }
        do {
            let expression = try NSRegularExpression(pattern: stringToHighlight, options: [.caseInsensitive, .ignoreMetacharacters])
            return expression.matches(in: self, options: [], range: NSRange(location: 0, length: count))
        } catch {
            print("status=could-not-create-regex error=\(error)")
            return []
        }
    }
    
}


public extension NSAttributedString {
    
    public func withIncreasedFontSize(by multiplier: CGFloat) -> NSAttributedString {
        let mutableCopy = NSMutableAttributedString(attributedString: self)
        mutableCopy.increaseFontSize(by: multiplier)
        return mutableCopy
    }
    
}
