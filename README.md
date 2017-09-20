# SwipeableTableViewCell



Ever had difficulties in implementing swipeable tableView cells with more buttons?  
Would it be simple if you had a protocol and upon implementing it you would have full swipe feature for your cell. :)

Yes you heard it right!

Just implement the **AlfaCellProtocol**



## Example
Custom table view cell that implements the protocol
```
class AlfaTableViewCell: UITableViewCell,AlfaCellProtocol {
    
    var isIndexPathOpened: Bool = false

    var updateTableViewToCloseAllOtherOpenCell: () -> () = {() in}

    var dataIndex: Int = 0

    var swipeGestureAdded: Bool = false

    var callBackBlocksforEach: [(Int) -> ()] = []

    var optionButtonBGColors: [UIColor] = []

    var optionTitles: [String] = []

    typealias Cell = UITableViewCell
}
```
ViewController:
Here we set the button actions for the buttons in table view cell
Below example adds two buttons labeled `info, delete` with background colors as `lightGray, red` and two closures for two button's touch events.  
`cellForRowAtIndexPath`
```
cell.optionTitles = ["Info","Delete"]
cell.optionButtonBGColors = [.lightGray, .red]
let infoBlock = {(index:Int) in
    self.info(index: index)
}
let deleteBlock = {(index:Int) in
    self.delete(index: index)
}
cell.callBackBlocksforEach = [infoBlock, deleteBlock]
cell.dataIndex = indexPath.row
```

If you want to add one more button to a cell then just modify the array like
In below example I'm adding a `more` button to the cell.
```
cell.optionTitles = ["more", "Info", "Delete"]
cell.optionButtonBGColors = [.blue, .lightGray, .red]
let infoBlock = {(index:Int) in
    self.info(index: index)
}
let deleteBlock = {(index:Int) in
    self.delete(index: index)
}
let moreBlock = {(index:Int) in
    self.more(index: index)
}
cell.callBackBlocksforEach = [moreBlock, infoBlock, deleteBlock]
cell.dataIndex = indexPath.row
```
## Contributions
Contributions to this repo are welcomed and encouraged!!!

