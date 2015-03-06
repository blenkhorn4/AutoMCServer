import Cocoa

class OptionsViewController: NSViewController {
    
    var folder: NSURL = NSURL(fileURLWithPath: NSHomeDirectory().stringByAppendingPathComponent("Desktop"))!

    @IBOutlet var servertype: NSSegmentedControl!
    @IBOutlet var ram: NSTextField!
    @IBOutlet var bytes: NSPopUpButton!
    @IBOutlet var username: NSTextField!
    @IBOutlet var choosefolder: NSPopUpButton!
    
    @IBOutlet var worldtype: NSPopUpButton!
    @IBOutlet var gamemode: NSPopUpButton!
    @IBOutlet var difficulty: NSPopUpButton!
    @IBOutlet var maxplayers: NSTextField!
    @IBOutlet var motd: NSTextField!
    @IBOutlet var nether: NSButton!
    @IBOutlet var mobs: NSButton!
    @IBOutlet var whitelist: NSButton!
    @IBOutlet var pvp: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        choosefolder.itemAtIndex(0)?.image = NSWorkspace.sharedWorkspace().iconForFile(folder.path!)
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if let segue = segue as? DismissSegue {
            segue.nextViewControllerIdentifier = "CreationView"
        }
        var ramv = ram.integerValue
        var bytesize = "M"
        if bytes.titleOfSelectedItem == "Megabytes" {
            ramv = ramv == 0 ? 1024 : ramv
        } else {
            bytesize = "G"
            ramv = ramv == 0 ? 2 : ramv
        }
        var maxplayer = maxplayers.integerValue
        maxplayer = maxplayer == 0 ? 20 : maxplayer
        var motds = motd.stringValue
        motds = motds == "" ? "A Minecraft Server" : motds

        let options = ServerOptions(path: folder.path!, servertype: getServerType(), ram: ramv, bytesize: bytesize, username: username.stringValue)
        Data.options = options
        let properties:ServerProperties = ServerProperties(nether: nether.isPressedIn(), leveltype: LevelType(rawValue: worldtype.titleOfSelectedItem!)!, mobs: mobs.isPressedIn(), whitelist: whitelist.isPressedIn(), pvp: pvp.isPressedIn(), difficulty: Difficulty(rawValue: difficulty.indexOfSelectedItem)!, gamemode: GameMode(rawValue: gamemode.indexOfSelectedItem)!, maxplayers: maxplayer, motd: motds)
        Data.properties = properties
    }
    
    @IBAction func choosefolder(sender: AnyObject) {
        var openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                self.folder = openPanel.URLs[0] as NSURL
                self.choosefolder.itemAtIndex(0)?.title = self.folder.lastPathComponent!
                self.choosefolder.itemAtIndex(0)?.image = NSWorkspace.sharedWorkspace().iconForFile(self.folder.path!)
                self.choosefolder.selectItemAtIndex(0)
            }
        }
    }
    
    @IBAction func changebytes(sender: AnyObject) {
        if bytes.titleOfSelectedItem == "Megabytes" {
           ram.placeholderString = "1024"
        } else {
            ram.placeholderString = "2"
        }
    }
    
    func getServerType() -> ServerType {
        return ServerType(rawValue: servertype.labelForSegment(servertype.selectedSegment)!)!
    }
}
extension NSButton {
    func isPressedIn() -> Bool {
        return self.state == 1 ? true : false
    }
}