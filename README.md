# DecoyXCUI

`DecoyXCUI` is an extension to the `Decoy` framework, providing an `XCTestCase` subclass named `DecoyUITestCase`.

This subclass is intended to be the foundation from which all Decoy tests should inherit.

*Note: This package should be imported into your UI testing target, not your app target.*

## Setup Instructions

* Tap your app's project in the Project Navigator.
* Under "Targets", tap your app's UI testing target.
* Tap Build Phases.
* Unfold the "Link Binary With Libraries" section.
* Use the plus icon to add both Decoy and DecoyXCUI to the list.
* Ensure they are both assigned the 'Required' status.

## Usage

In your test classes that subclass `DecoyUITestCase`, initiate the setup as follows:

```
override func setUp() {
  super.setUpDecoy(mode: .stubbing)
}
```

When you want to record a decoy, first decide for how many days you'd like your mock to be valid.
In this case, we're saying 7 days – you can use 0 for an always-valid recording. Then, set up like this:

```
override func setUp() {
  super.setUpDecoy(mode: .recording(7))
}
```

This will launch your app with the required environment variables to use Decoy.

## Feedback & Contributions

Feel free to open an issue or submit a pull request if you have any improvements or feedback.
