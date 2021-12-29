const Lang = imports.lang;
const St = imports.gi.St;
const Main = imports.ui.main;
const PopupMenu = imports.ui.popupMenu;
const UUID = 'wifier@eli';

function ConfirmDialog(){
  this._init();
}

function MyApplet(orientation, panelHeight, instanceId) {
  this._init(orientation, panelHeight, instanceId);
}

MyApplet.prototype = {
  __proto__: Applet.IconApplet.prototype,

  _init: function(orientation, panelHeight, instanceId) {
    Applet.IconApplet.prototype._init.call(this, orientation, panelHeight, instanceId);
/*
    try {
      this.set_applet_icon_name("wifi-icon-off");
      this.set_applet_tooltip("Control Wifi access point");

      this.menuManager = new PopupMenu.PopupMenuManager(this);
      this.menu = new Applet.AppletPopupMenu(this, orientation);
      this.menuManager.addMenu(this.menu);

      this._contentSection = new PopupMenu.PopupMenuSection();
      this.menu.addMenuItem(this._contentSection);

      // First item: Turn on
      let item = new PopupMenu.PopupIconMenuItem("Access point on", "wifi-icon-on", St.IconType.FULLCOLOR);

      item.connect('activate', Lang.bind(this, function() {
					   Main.Util.spawnCommandLine("/usr/local/bin/access-point-ctl on");
					 }));
      this.menu.addMenuItem(item);

      // Second item: Turn off
      item = new PopupMenu.PopupIconMenuItem("Access point off", "wifi-icon-off", St.IconType.FULLCOLOR);

      item.connect('activate', Lang.bind(this, function() {
					   Main.Util.spawnCommandLine("/usr/local/bin/access-point-ctl off");
					 }));
      this.menu.addMenuItem(item);
    }
    catch (e) {
      global.logError(e);
    }
    */
  },

  on_applet_clicked: function(event) {
    this.menu.toggle();
  },
};

function main(metadata, orientation, panelHeight, instanceId) {
  let myApplet = new MyApplet(orientation, panelHeight, instanceId);
  return myApplet;
}
