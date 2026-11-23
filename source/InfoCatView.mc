import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;
import Toybox.WatchUi;
import Toybox.Weather;

class InfoCatView extends WatchUi.WatchFace {
    private var faceWidth;
    private var faceHeight;
    private var background;
    private var pawPrints;
    private var stairs;
    private var heart;
    private var sun;
    private var moon;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        faceWidth = dc.getWidth();
        faceHeight = dc.getHeight();
        background = WatchUi.loadResource(Rez.Drawables.Cat);
        pawPrints = WatchUi.loadResource(Rez.Drawables.PawPrints);
        stairs = WatchUi.loadResource(Rez.Drawables.Stairs);
        heart = WatchUi.loadResource(Rez.Drawables.Heart);
        sun = WatchUi.loadResource(Rez.Drawables.Sun);
        moon = WatchUi.loadResource(Rez.Drawables.Moon);
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
        drawTemperature(dc);
        drawSteps(dc);
        drawFloorsClimbed(dc);
        drawHeartRate(dc);
        drawDaylightProgress(dc);
        drawDate(dc);
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

    private function drawTemperature(dc as Dc) as Void {
        var conditions = Weather.getCurrentConditions();
        var settings = System.getDeviceSettings();
        var temperatureText = "--";
        
        if ((conditions != null) && (conditions.feelsLikeTemperature != null)) {
            var temperature = conditions.feelsLikeTemperature.toFloat();
            // regardless of set units temperature is stored as Celsius
            if (settings.temperatureUnits == System.UNIT_STATUTE) {
                // there we need to check if units are set to Fahrenheit and convert
                temperature = (temperature * 9.0 / 5.0) + 32.0;
            }
            temperatureText = temperature.format("%.0f") + "°";
        }

        var font = Graphics.getVectorFont({:face => "RobotoCondensedBold", :size => 20});
        var x = faceWidth * 0.51;
        var y = faceHeight * 0.64;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, temperatureText, Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawRoundedArc(
        dc as Dc,
        centerX as Lang.Numeric,
        centerY as Lang.Numeric,
        radius as Lang.Numeric,
        startAngle as Lang.Numeric,
        endAngle as Lang.Numeric,
        color as Graphics.ColorType
    ) as Void {
        var lineWidth = 5;
        var capRadius = lineWidth / 2.0;
        var startRadians = startAngle * Math.PI / 180.0;
        var endRadians = endAngle * Math.PI / 180.0;

        dc.setPenWidth(lineWidth);
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(centerX, centerY, radius, Graphics.ARC_COUNTER_CLOCKWISE, startAngle, endAngle);
        dc.fillCircle(centerX + radius * Math.cos(startRadians), centerY - radius * Math.sin(startRadians), capRadius);
        dc.fillCircle(centerX + radius * Math.cos(endRadians), centerY - radius * Math.sin(endRadians), capRadius);
    }

    private function drawDaylightProgress(dc as Dc) as Void {
        var progress = 0.0;
        var conditions = Weather.getCurrentConditions();

        if ((conditions != null) && (conditions.observationLocationPosition != null)) {
            var now = Time.now();
            var location = conditions.observationLocationPosition;
            var sunrise = Weather.getSunrise(location, now);
            var sunset = Weather.getSunset(location, now);

            if ((sunrise != null) && (sunset != null) && (sunset.value() > sunrise.value())) {
                if (now.value() >= sunset.value()) {
                    progress = 1.0;
                } else if (now.value() > sunrise.value()) {
                    progress = (now.value() - sunrise.value()).toFloat() /
                        (sunset.value() - sunrise.value()).toFloat();
                }
            }
        }

        var startAngle = 245;
        var endAngle = 295;
        var offset = faceHeight * 0.02;
        var radius = (faceWidth / 2) - offset;
        var centerX = faceWidth / 2;
        var centerY = faceHeight - radius - offset;

        drawRoundedArc(dc, centerX, centerY, radius, startAngle, endAngle, Graphics.COLOR_DK_GRAY);

        if (progress > 0.0) {
            var progressEndAngle = Math.floor(startAngle + ((endAngle - startAngle) * progress));

            if (progressEndAngle > startAngle) {
                drawRoundedArc(dc, centerX, centerY, radius, startAngle, progressEndAngle, Graphics.COLOR_WHITE);
            }
        }

        var iconSize = Graphics.getFontHeight(Graphics.FONT_XTINY);
        var sunX = faceWidth * 0.22;
        var sunY = faceHeight * 0.86;
        var moonX = faceWidth * 0.7;
        var moonY = faceHeight * 0.865;

        dc.drawScaledBitmap(sunX, sunY, iconSize, iconSize, sun);
        dc.drawScaledBitmap(moonX, moonY, iconSize, iconSize, moon);
    }

    private function drawDate(dc as Dc) as Void {
        var dateInfo = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dayOfWeek = dateInfo.day_of_week.toLower();
        var dayOfMonth = dateInfo.day.toString();
        var font = Graphics.FONT_XTINY;
        var dayOfWeekWidth = dc.getTextDimensions(dayOfWeek, font)[0];
        var dayOfWeekX = (faceWidth / 2) - (dayOfWeekWidth / 2);
        var dayOfWeekY = faceHeight * 0.823;
        var dayOfMonthWidth = dc.getTextDimensions(dayOfMonth, font)[0];
        var dayOfMonthX = (faceWidth / 2) - (dayOfMonthWidth / 2);
        var dayOfMonthY = dayOfWeekY + (faceHeight * 0.054);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dayOfWeekX, dayOfWeekY, font, dayOfWeek, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(dayOfMonthX, dayOfMonthY, font, dayOfMonth, Graphics.TEXT_JUSTIFY_LEFT);
    }

    private function formatActivityCount(count as Number) as String {
        var countText = count.toString();
        if (count >= 100000) {
            countText = (count.toFloat() / 1000.0).format("%.0f") + "k";
        } else if (count >= 10000) {
            var tenthsOfThousands = Math.floor(count.toFloat() / 100.0);
            countText = (tenthsOfThousands / 10.0).format("%.1f") + "k";
        }

        return countText;
    }

    private function drawSteps(dc as Dc) as Void {
        var activityInfo = ActivityMonitor.getInfo();
        var stepsText = "--";

        if ((activityInfo has :steps) && (activityInfo.steps != null)) {
            stepsText = formatActivityCount(activityInfo.steps);
        }

        var font = Graphics.FONT_XTINY;
        var iconSize = Graphics.getFontHeight(font);
        var textWidth = dc.getTextDimensions(stepsText, font)[0];
        var iconX = (faceWidth / 2) - (iconSize + textWidth) / 2;
        var textX = iconX + iconSize;
        var y = faceHeight * 0.11;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawScaledBitmap(iconX, y, iconSize, iconSize, pawPrints);
        dc.drawText(textX, y, font, stepsText, Graphics.TEXT_JUSTIFY_LEFT);
    }

    private function drawFloorsClimbed(dc as Dc) as Void {
        var activityInfo = ActivityMonitor.getInfo();
        var floorsText = "--";

        if ((activityInfo has :floorsClimbed) && (activityInfo.floorsClimbed != null)) {
            floorsText = formatActivityCount(activityInfo.floorsClimbed);
        }

        var font = Graphics.FONT_XTINY;
        var iconX = faceWidth * 0.53;
        var iconSize = Graphics.getFontHeight(font);
        var textX = iconX + iconSize;
        var y = faceHeight * 0.04;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawScaledBitmap(iconX, y, iconSize, iconSize, stairs);
        dc.drawText(textX, y, font, floorsText, Graphics.TEXT_JUSTIFY_LEFT);
    }

    private function drawHeartRate(dc as Dc) as Void {
        var activityInfo = Activity.getActivityInfo();
        var heartRateText = "--";

        if ((activityInfo has :currentHeartRate) && (activityInfo.currentHeartRate != null)) {
            heartRateText = activityInfo.currentHeartRate.toString();
        }

        var font = Graphics.FONT_XTINY;
        var iconX = faceWidth * 0.3;
        var iconSize = Graphics.getFontHeight(font);
        var textX = iconX + iconSize;
        var y = faceHeight * 0.04;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawScaledBitmap(iconX, y, iconSize, iconSize, heart);
        dc.drawText(textX, y, font, heartRateText, Graphics.TEXT_JUSTIFY_LEFT);
    }
}
