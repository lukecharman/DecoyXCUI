import XCTest
import Decoy

open class DecoyUITestCase: XCTestCase {

  public var app: XCUIApplication!

  public func setUp(path: String = #filePath, recording: Bool) {
    super.setUp()

    var url = URL(string: path)!.deletingLastPathComponent()
    url.safeAppend(path: DecoyHub.Constants.decoysFolder)

    app = XCUIApplication()

    app.launchEnvironment[DecoyHub.Constants.isRecording] = String(recording)
    app.launchEnvironment[DecoyHub.Constants.isXCUI] = String(true)
    app.launchEnvironment[DecoyHub.Constants.decoyPath] = url.absoluteString
    app.launchEnvironment[DecoyHub.Constants.decoyFilename] = "\(decoyName).json"

    app.launch()
  }
}

public extension DecoyUITestCase {

  var decoyName: String {
    name
      .split(separator: " ")
      .last!
      .replacingOccurrences(of: "]", with: "")
  }
}

private extension URL {

  init(safePath path: String) {
    if #available(iOS 16, *) {
      self.init(filePath: path)
    } else {
      self.init(fileURLWithPath: path)
    }
  }

  mutating func safeAppend(path: String) {
    if #available(iOS 16, *) {
      self.append(path: path)
    } else {
      self.appendPathComponent(path)
    }
  }
}
