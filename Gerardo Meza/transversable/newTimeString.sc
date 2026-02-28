+ SimpleNumber

{
	
asTimeStringCage { arg precision = 0.001, maxDays = 365, dropDaysIfPossible = true;
		var decimal, days, hours, minutes, seconds, mseconds;
		decimal = this.asInteger;
		days = decimal.div(86400).min(maxDays);
		days = if(dropDaysIfPossible and: { days == 0 }) {
			days = ""
		} {
			days.asString.padLeft(3, "0").add($:);
		};
		hours = (decimal.div(3600) % 24).asString.padLeft(2, "0").add($:);
		minutes = (decimal.div(60) % 60).asString.padLeft(2, "0").add($:);
		seconds = (decimal % 60).asString.padLeft(2, "0");
		mseconds = (this.frac / precision).round(precision).asInteger.asString.padLeft(3, "0");
//		^days ++ hours ++ minutes ++ seconds ++ mseconds
		^minutes ++ seconds
	}
	
	
}