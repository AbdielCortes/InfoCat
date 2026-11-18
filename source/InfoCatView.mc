import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class InfoCatView extends WatchUi.WatchFace {
    private var faceWidth;
    private var faceHeight;
    private var background;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        faceWidth = dc.getWidth();
        faceHeight = dc.getHeight();
        background = WatchUi.loadResource(Rez.Drawables.Cat);
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

        drawBackground(dc);
        drawTime(dc);
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

    private function drawBackground(dc as Dc) as Void {
        dc.drawScaledBitmap(0, 0, faceWidth, faceHeight, background);
    }

    private function drawTime(dc as Dc) as Void {
        var clockTime = System.getClockTime();
        var hoursText = Lang.format("$1$", [clockTime.hour]);
        var minutesText = clockTime.min.format("%02d");
        var timeFont = Graphics.getVectorFont({:face => "RobotoCondensedBold", :size => 61});

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(faceWidth * 0.3, faceHeight * 0.345, timeFont, hoursText, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(faceWidth * 0.698, faceHeight * 0.345, timeFont, minutesText, Graphics.TEXT_JUSTIFY_CENTER);
    }

}
