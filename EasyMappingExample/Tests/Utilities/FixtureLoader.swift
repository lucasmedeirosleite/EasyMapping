//
//  EasyMapping
//
//  Copyright (c) 2012-2017 Lucas Medeiros.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

final class FixtureLoader {
    static func json(fromFileNamed fileName: String) -> Any {
        let bundle = Bundle(for: self)
        if let filePath = bundle.path(forResource: fileName, ofType: nil),
            let data = NSData(contentsOfFile: filePath) as Data?
        {
            if let object = try? JSONSerialization.jsonObject(with: data, options: []) {
                return object
            }
        }
        return [:]
    }
    
    static func dictionary(fromFileNamed fileName: String) -> [String:Any] {
        return json(fromFileNamed: fileName) as? [String:Any] ?? [:]
    }
    
    static func array(fromFileNamed fileName: String) -> [[String:Any]] {
        return json(fromFileNamed: fileName) as? [[String:Any]] ?? []
    }
}
