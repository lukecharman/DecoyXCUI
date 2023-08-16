import XCTest
import Decoy

/// Custom test case class tailored for Decoy-based UI tests.
open class DecoyUITestCase: XCTestCase {

  /// Application instance used for UI tests.
  public var app: XCUIApplication!

  /// Sets up the testing environment for Decoy-based UI tests.
  /// - Parameters:
  ///   - path: The file path at which decoy configurations will be read from or written to. Defaults to the current file path.
  ///   - mode: The mode in which the tests in this case should run.
  public func setUpDecoy(path: String = #filePath, mode: Decoy.TestMode) {
    super.setUp()

    /// Prepare the URL based on the provided path.
    guard var url = preparedURL(path: path) else {
      XCTFail("Setup failed to resolve path: \(path) to a URL.")
      return
    }

    /// Extract the decoy name based on the test's name.
    guard let decoyName = decoyName else {
      XCTFail("Could not resolve test name from \(name)")
      return
    }

    /// Check whether the stub has expired. If so, fail the test up front to avoid wasting time.
    guard !stubHasExpired(at: url, name: decoyName) else {
      XCTFail("Stub has been recorded, but has expired. Needs to be re-recorded.")
      return
    }

    /// Initialize the app instance.
    app = XCUIApplication()

    /// Set environment variables for the app launch.
    prepareEnvironment(url: url, mode: mode, name: decoyName)

    /// Launch the application for UI testing.
    app.launch()
  }

  /// Extracts the decoy name from the test's name by removing any trailing "]" and retrieving the last component.
  public var decoyName: String? {
    guard let decoyName = name
      .replacingOccurrences(of: "]", with: "")
      .split(separator: " ")
      .last
    else {
      return nil
    }

    return String(decoyName)
  }
}

private extension DecoyUITestCase {
  /// Modifies the provided path to derive the URL for decoy configurations.
  /// - Parameter path: The original file path.
  /// - Returns: A modified URL pointing to the decoy configurations or `nil` if the URL can't be constructed.
  func preparedURL(path: String) -> URL? {
    var url = URL(string: path)

    url?.deleteLastPathComponent()
    url?.safeAppend(path: Decoy.Constants.decoysFolder)

    return url
  }

  /// Sets the necessary environment variables before the app launch.
  /// - Parameters:
  ///   - url: The URL pointing to decoy configurations.
  ///   - mode: Indicates the mode in which the test is running (i.e. `recording` or `stubbing`.
  ///   - name: The name of the test.
  func prepareEnvironment(url: URL, mode: Decoy.TestMode, name: String) {
    app.launchEnvironment[Decoy.Constants.isXCUI] = String(true)
    app.launchEnvironment[Decoy.Constants.decoyMode] = mode.stringValue
    app.launchEnvironment[Decoy.Constants.decoyPath] = url.absoluteString
    app.launchEnvironment[Decoy.Constants.decoyFilename] = (name + ".json")
  }

  func stubHasExpired(at url: URL, name: String) -> Bool {
    guard var fileURL = URL(string: "file://" + url.absoluteString) else {
      return false
    }

    fileURL.safeAppend(path: name + ".json")

    do {
      /// Read the file's content
      let data = try Data(contentsOf: fileURL)

      /// Decode the JSON to get the "expiresAt" value
      guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
        return true
      }

      /// Parse it and check the date.
      print(json)
    } catch {
      return false
    }

    return false
  }
}

/// Extension for the URL class to provide safer path operations tailored for different iOS versions.
private extension URL {

  /// Initializes a URL based on the file path, considering iOS version specifics.
  /// - Parameter path: The file path.
  init(safePath path: String) {
    if #available(iOS 16, *) {
      self.init(filePath: path)
    } else {
      self.init(fileURLWithPath: path)
    }
  }

  /// Appends a path component to the URL, considering iOS version specifics.
  /// - Parameter path: The path component to append.
  mutating func safeAppend(path: String) {
    if #available(iOS 16, *) {
      self.append(path: path)
    } else {
      self.appendPathComponent(path)
    }
  }
}
