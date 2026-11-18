import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class InfoCatView extends WatchUi.WatchFace {
    private var background;
    // private var timeFont;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        background = WatchUi.loadResource(Rez.Drawables.Cat);
        // timeFont = WatchUi.loadResource(Rez.Fonts.TimeFont) as WatchUi.FontResource;
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var clockTime = System.getClockTime();
        var hoursText = Lang.format("$1$", [clockTime.hour]);
        var minutesText = clockTime.min.format("%02d");
        var timeFont = Graphics.getVectorFont({:face => "RobotoCondensedRegular", :size => 62});
        var faceWidth = dc.getWidth();
        var faceHeight = dc.getHeight();

        View.onUpdate(dc);

        // Draw cat background
        dc.drawScaledBitmap(0, 0, faceWidth, faceHeight, background);
        // Draw hour and minutes
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(faceWidth * 0.30, faceHeight * 0.345, timeFont, hoursText, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(faceWidth * 0.7, faceHeight * 0.345, timeFont, minutesText, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
