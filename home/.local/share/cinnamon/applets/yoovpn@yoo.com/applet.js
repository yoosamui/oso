const Lang = imports.lang;
const Applet = imports.ui.applet;
const GLib = imports.gi.GLib;
const Gettext = imports.gettext;
const UUID = "yoovpn@yoo.com";
const Settings = imports.ui.settings;
const Mainloop = imports.mainloop;
const Util = imports.misc.util;
const Gio = imports.gi.Gio; // Needed for file infos
const St = imports.gi.St;




//const Applet = imports.ui.applet;
//const PopupMenu = imports.ui.popupMenu;
//const St = imports.gi.St;
const Gtk = imports.gi.Gtk;
const Soup = imports.gi.Soup;
//const _httpSession = new Soup.SessionAsync();
//const Lang = imports.lang;
//const Mainloop = imports.mainloop;
//const Settings = imports.ui.settings;
//const Gio = imports.gi.Gio;
//const GLib = imports.gi.GLib;


Gettext.bindtextdomain(UUID, GLib.get_home_dir() + "/.local/share/locale");

const Debugger = {
    logLevel: 0,
    log: function (message, level) {
        if (!level) {
            level = 1;
        }
        if (level <= this.logLevel) {
            global.log(message);
        }
    }
};



function _(str) {
    return Gettext.dgettext(UUID, str);
}

function MyApplet(metadata, orientation, panelHeight, instanceId) {
    this._init(metadata, orientation, panelHeight, instanceId);
    
    
   
}

MyApplet.prototype = {
    __proto__: Applet.IconApplet.prototype,

    _init: function(metadata, orientation, panelHeight, instanceId) {
        Applet.IconApplet.prototype._init.call(this, orientation, panelHeight, instanceId);

        try {
            
            
            this.icon_connected = metadata.path + '/icon.png';
            this.icon_disconnected = metadata.path + '/icon-grey.png';
        
        
            //this.set_applet_icon_symbolic_name("nm-no-connection");
            // /usr/share/icons/)
           // this.set_applet_icon_symbolic_name("emblem-web");
       //     this.set_applet_label("...");
            this.mode = true;
            
            //this.icon_theme = Gtk.IconTheme.get_default();
            this.set_applet_tooltip(_("Disconnected"));
           // this.actor.connect('button-release-event', Lang.bind(this, this._onButtonReleaseEvent));
            
       // Debugger.log("Update interval ifconfig = 2",2);    
            //this.set_applet_label(" HALLO");
        // global.logError("AAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
            
            
            this._getNetworkInterfacesPath = metadata.path + "/getvpnstatus.sh";
            
            this.loopId = 0;
           // this.updatePeriodic();
   // this.loopId = Mainloop.timeout_add_seconds( /*this.state.interval*/ 10, () => /////////////this.updatePeriodic());
    
            this.updatePeriodic();
    
    
    this.content = _('Please install expressvpn.');
    
        }
        catch (e) {
            global.logError(e);
        }
    },
    updatePeriodic: function () {
       
        this.loopId = Mainloop.timeout_add_seconds( /*this.state.interval*/ 10, () => this.updatePeriodic());
        
        
       // global.logError("Executing " + this._getNetworkInterfacesPath);
        let output = GLib.spawn_command_line_sync(this._getNetworkInterfacesPath);
       // let interfaces = output[1].toString().split("\n");
        
        this.status = output[1].toString().trim(); 
        //this.status = output[1].toString().trimStart(); 
        
        global.logError(this.status);
        
        if( this.status.indexOf("Connected") != -1 ) {
            //this.set_applet_icon_symbolic_name("nm-no-connection");
            this.set_applet_icon_path(this.icon_connected);
        }
        else
        {
            this.set_applet_icon_path(this.icon_disconnected);
            //this.set_applet_icon_symbolic_name("emblem-web");
            
        }
        
        
        this.set_applet_tooltip(this.status);
        
      
        
    },
    removeTimer: function () {
    //    if (this._periodicTimeoutIfconfigId) {
    //        Mainloop.source_remove(this._periodicTimeoutIfconfigId);
     //   }
       // if (this._periodicTimeoutIpServiceId) {
         //   Mainloop.source_remove(this._periodicTimeoutIpServiceId);
       // }
        
        Mainloop.source_remove(this.loopId);
        this.loopId = 0;
    },

    on_applet_removed_from_panel: function () {
        this.removeTimer();
        //this.settings.finalize();
    },
    
    _onButtonReleaseEvent: function(actor, event) {
        if (this._applet_enabled) {
            if (event.get_button() == 1) {
                if (!this._draggable.inhibit) {
                    return false;
                } else {
                    GLib.spawn_command_line_async('xkill');
                }
            }
        }
        return true;
    }

};

function main(metadata, orientation, panelHeight, instanceId) {
    let myApplet = new MyApplet(metadata, orientation, panelHeight, instanceId);
    return myApplet;
}
