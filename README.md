# ListsView

ListsView allow you to display different kinds of lists, depending on the type of collection you'll give it.

- Array -> flat list
- Page -> sectioned list
- Book -> multi-page (sectioned) list

See [Book](https://github.com/greg3z/Book) for the Page and Book collection types.

Once initialised with the appropriate CollectionType, you can set 3 closures to specify how your list works:

```swift
let cellType: Element -> UITableViewCell.Type
```

cellType allows you to specify the UITableViewCell subclass to use for a given element. It allows you to use different kind of cells, ListsView will take care of dequeuing the appropriate cell for your element. If you don't specify it, UITableViewCell will be used by default.

```swift
var configureCell: (Element, UITableViewCell, UITableView, NSIndexPath) -> Void
```

configureCell let you populate a given cell with the data of a given element. The table view and index path are communicated through the closure for specific needs, such as testing this is still the current cell in case of asynchronous task, like loading an image from the network.

```swift
var elementTouched: (Element, UITableViewCell) -> Void
```

elementTouched tells you when a user touched an element. The cell is returned as well for convenience.
