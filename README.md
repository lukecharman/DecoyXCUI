# DecoyXCUI

An `XCTestCase` subclass named `DecoyUITestCase` from which all Decoy tests should inherit.

This package should be imported into your UI testing target, not your app target. To do this:
* Tap your app's project in the Project Navigator.
* Under "Targets", tap your app's UI testing target.
* Tap Build Phases.
* Unfold the "Link Binary With Libraries" section.
* Use the plus icon to add both `Decoy` and `DecoyXCUI` to the list.
* Ensure they are both assigned the 'Required' status.

In your own test classes that subclass `DecoyUITestCase`, there's just one thing to do:
* Call the custom `setUp()` method, like so, passing in whether or not you'd like to record.
* This will launch your app with the requires environment variables to use Decoy.

```
override func setUp() {
  super.setUp(recording: false)
}
```
