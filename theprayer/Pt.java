import java.util.Arrays;
import java.util.Calendar;
import java.util.TimeZone;

@SuppressWarnings({"WeakerAccess", "unused"})
public class Pt {

    // ------------------------ Constants --------------------------

    public static final String ICON = "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";

    // Juristic Methods
    public static final byte SHAFII = 0; // Shafii (standard)
    public static final byte HANAFI = 1; // Hanafi

    // Adjusting Methods for Higher Latitudes
    public static final byte NONE = 0; // No adjustment
    public static final byte MIDNIGHT = 1; // middle of night
    public static final byte ONE_SEVENTH = 2; // 1/7th of night
    public static final byte ANGLE_BASED = 3; // angle/60th of night

    // Time Formats
    public static final byte TIME_24 = 0; // 24-hour format
    public static final byte TIME_12 = 1; // 12-hour format
    public static final byte TIME_12_NS = 2; // 12-hour format with no suffix

    // times indices
    public static final byte
        FAJR = 0,
        FAJR_IQAMA = 1,
        SUNRISE = 2,
        DUHR = 3,
        DUHR_IQAMA = 4,
        ASR = 5,
        ASR_IQAMA = 6,
        SUNSET = 7,
        MAGRIB = 8,
        MAGRIB_IQAMA = 9,
        ISHA = 10,
        ISHA_IQAMA = 11;

    public static final byte[] SIMPLE_TIMES = {
        FAJR, SUNRISE, DUHR, ASR, MAGRIB, ISHA
    };

    public static final byte[] SIMPLE_TIMES_WITH_IQAMA = {
        FAJR, FAJR_IQAMA, SUNRISE, DUHR, DUHR_IQAMA, ASR,
        ASR_IQAMA, MAGRIB, MAGRIB_IQAMA, ISHA, ISHA_IQAMA
    };

    // --------------------- Technical Settings --------------------

    private static final int NUM_ITERATIONS = 1; // number of iterations needed to compute times

    // ------------------- Calc Methods ---------------------------

    public static class Method {
        float fajrAngle;
        boolean magribIsMinuets; // true = minutes after sunset, false = angle
        float magribVal;
        boolean ishaIsMinuets; // true = minutes after sunset, false = angle
        float ishaVal;

        public Method(float fajrAngle, boolean magribIsMinuets, float magribVal, boolean ishaIsMinuets, float ishaVal) {
            this.fajrAngle = fajrAngle;
            this.magribIsMinuets = magribIsMinuets;
            this.magribVal = magribVal;
            this.ishaIsMinuets = ishaIsMinuets;
            this.ishaVal = ishaVal;
        }

        public Method(float fajrAngle, int magribIsMinuets, float magribVal, int ishaIsMinuets, float ishaVal) {
            this.fajrAngle = fajrAngle;
            this.magribIsMinuets = magribIsMinuets == 1;
            this.magribVal = magribVal;
            this.ishaIsMinuets = ishaIsMinuets == 1;
            this.ishaVal = ishaVal;
        }

        public Method from(Method from) {
            this.fajrAngle = from.fajrAngle;
            this.magribIsMinuets = from.magribIsMinuets;
            this.magribVal = from.magribVal;
            this.ishaIsMinuets = from.ishaIsMinuets;
            this.ishaVal = from.ishaVal;
            return this;
        }

    }

    // Calculation Methods
    public static final Method
        /* 1 */KARACHI = new Method(18f, 1, 0f, 0, 18f),
        /* 2 */ISNA = new Method(15f, 1, 0f, 0, 15f),
        /* 3 */MWL = new Method(18f, 1, 0f, 0, 17f),
        /* 4 */MAKKAH = new Method(18.5f, 1, 0f, 1, 90f),
        /* 5 */EGYPT = new Method(19.5f, 1, 0f, 0, 17.5f),
        /* 7 */CUSTOM = new Method(18f, 1, 0f, 0, 17f),
        /* 8 */QATAR = new Method(18f, 1, 0f, 1, 90f),
        /*11 */ALGERIA = new Method(18f, 1, 3f, 0, 17f),
        /*18 */JORDAN = new Method(18f, 1, 0f, 0, 18f),
        /*19 */KUWAIT = new Method(18f, 1, 0f, 0, 17.5f),
        /*22 */ENGLAND_BIRMINGHAM = new Method(18f, 1, 0f, 0, 17f),
        /*23 */ENGLAND_LONDON = new Method(18f, 1, 0f, 0, 17f),
        /*24 */GERMANY_MUNCHEN = new Method(18f, 1, 0f, 0, 17f),
        /*25 */GERMANY_AACHEN = new Method(18f, 1, 0f, 0, 17f);

    public static final int
        KARACHI_INT = 1, // University of Islamic Sciences, Karachi
        ISNA_INT = 2, // Islamic Society of North America (ISNA)
        MWL_INT = 3, // Muslim World League (MWL)
        MAKKAH_INT = 4, // Umm al-Qura, Makkah
        EGYPT_INT = 5, // Egyptian General Authority of Survey
        CUSTOM_INT = 7, // Custom Setting
        QATAR_INT = 8, // Qatar Calendar House
        ALGERIA_INT = 11, // Algeria, Ministry of Religious Affairs and Endowments
        JORDAN_INT = 18, // Jordan, Ministry of Awqaf, Islamic Affairs and Holy Places
        KUWAIT_INT = 19, // Kuwait, Ministry of Awqaf and Islamic Affairs
        ENGLAND_BIRMINGHAM_INT = 22, // United Kingdom, Birmingham Central Mosque
        ENGLAND_LONDON_INT = 23, // United Kingdom, London Central Mosque
        GERMANY_MUNCHEN_INT = 24, // Germany, Islamic Center of Munich
        GERMANY_AACHEN_INT = 25; // Germany, Islamic Center of Aachen

    public static Method intToMethod(int i) {
        switch (i) {
        case KARACHI_INT:
            return KARACHI;
        case ISNA_INT:
            return ISNA;
        case MWL_INT:
            return MWL;
        case MAKKAH_INT:
            return MAKKAH;
        case EGYPT_INT:
            return EGYPT;
        case CUSTOM_INT:
            return CUSTOM;
        case QATAR_INT:
            return QATAR;
        case ALGERIA_INT:
            return ALGERIA;
        case JORDAN_INT:
            return JORDAN;
        case KUWAIT_INT:
            return KUWAIT;
        case ENGLAND_BIRMINGHAM_INT:
            return ENGLAND_BIRMINGHAM;
        case ENGLAND_LONDON_INT:
            return ENGLAND_LONDON;
        case GERMANY_MUNCHEN_INT:
            return GERMANY_MUNCHEN;
        case GERMANY_AACHEN_INT:
            return GERMANY_AACHEN;
        default:
            throw new RuntimeException("invalid method int (" + i + ")");
        }
    }

    // -------------------- Strings -------------------------------

    public String[] timesNames;
    public String strRemaining;
    public String strPassed;
    public String strToPray;
    public String strIqama;
    public String strToIqama;
    public String strFromIqama;
    public String strItsTimeFor;
    public String strHour;
    public String strHours;
    public String str2Hours;
    public String strMinute;
    public String strMinutes;
    public String str2Minutes;
    public String strAnd;

    // ---------------------- Global Variables --------------------

    public Method calcMethod = MAKKAH; // calculation method
    public byte asrJuristic = SHAFII; // Juristic method for Asr
    public byte dhuhrMinutes = 0; // minutes after mid-day for Dhuhr
    public byte adjustHighLats = ANGLE_BASED; // adjusting method for higher latitudes

    public byte timeFormat = TIME_12; // time format
    public boolean isAr = false; // is Arabic

    public double lat; // latitude
    public double lng; // longitude
    public double timeZone; // time-zone

    private double jDate; // Julian date
    public short[] times = new short[12]; // cached times
    public short[] offsets = new short[7];
    public short[] iqama = {25, 20, 25, 10, 20}; // iqama after {fajr, duhr, asr, magrib, isha} minutes

    private static Pt defaultPt;

    // ---------------------- Trigonometric Functions -----------------------

    // range reduce angle in degrees.
    private static double fixangle(double a) {
        a = a - (360 * (Math.floor(a / 360.0)));
        a = a < 0 ? (a + 360) : a;
        return a;
    }

    // range reduce hours to 0..23
    private static double fixhour(double a) {
        a = a - 24.0 * Math.floor(a / 24.0);
        a = a < 0 ? (a + 24) : a;
        return a;
    }

    // radian to degree
    private static double radiansToDegrees(double alpha) {
        return ((alpha * 180.0) / Math.PI);
    }

    // deree to radian
    private static double DegreesToRadians(double alpha) {
        return ((alpha * Math.PI) / 180.0);
    }

    // degree sin
    private static double dsin(double d) {
        return (Math.sin(DegreesToRadians(d)));
    }

    // degree cos
    private static double dcos(double d) {
        return (Math.cos(DegreesToRadians(d)));
    }

    // degree tan
    private static double dtan(double d) {
        return (Math.tan(DegreesToRadians(d)));
    }

    // degree arcsin
    private static double darcsin(double x) {
        double val = Math.asin(x);
        return radiansToDegrees(val);
    }

    // degree arccos
    private static double darccos(double x) {
        double val = Math.acos(x);
        return radiansToDegrees(val);
    }

    // degree arctan2
    private static double darctan2(double y, double x) {
        double val = Math.atan2(y, x);
        return radiansToDegrees(val);
    }

    // degree arccot
    private static double darccot(double x) {
        double val = Math.atan2(1.0, x);
        return radiansToDegrees(val);
    }

    // ---------------------- Time-Zone Functions -----------------------

    // compute base time-zone of the system
    public static double getBaseTimeZone() {
        TimeZone timez = TimeZone.getDefault();
        return (timez.getRawOffset() / 1000.0) / 3600;
    }

    // detect daylight saving in a given date
    public static double detectDaylightSaving() {
        TimeZone timez = TimeZone.getDefault();
        return (double) timez.getDSTSavings();
    }

    // ---------------------- Julian Date Functions -----------------------

    // calculate julian date from a calendar date
    private static double julianDate(int year, int month, int day) {
        if (month <= 2) {
            year -= 1;
            month += 12;
        }
        double A = Math.floor(year / 100.0);
        double B = 2 - A + Math.floor(A / 4.0);
        return Math.floor(365.25 * (year + 4716)) + Math.floor(30.6001 * (month + 1)) + day + B - 1524.5;
    }

    // convert a calendar date to julian date (second method)
    private static double julianDate2(int year, int month, int day) {
        double J1970 = 2440588.0;
        Calendar date = Calendar.getInstance();
        date.set(Calendar.YEAR, year);
        date.set(Calendar.MONTH, month - 1);
        date.set(Calendar.DATE, day);

        double ms = date.getTimeInMillis(); // # of milliseconds since midnight Jan 1, 1970
        double days = Math.floor(ms / (1000.0 * 60.0 * 60.0 * 24.0));
        return J1970 + days - 0.5;
    }

    // ---------------------- Calculation Functions -----------------------

    // References:
    // http://www.ummah.net/astronomy/saltime
    // http://aa.usno.navy.mil/faq/docs/SunApprox.html
    // compute declination angle of sun and equation of time
    private static double[] sunPosition(double jd) {

        double D = jd - 2451545;
        double g = fixangle(357.529 + 0.98560028 * D);
        double q = fixangle(280.459 + 0.98564736 * D);
        double L = fixangle(q + (1.915 * dsin(g)) + (0.020 * dsin(2 * g)));

        // double R = 1.00014 - 0.01671 * [self dcos:g] - 0.00014 * [self dcos: (2*g)];
        double e = 23.439 - (0.00000036 * D);
        double d = darcsin(dsin(e) * dsin(L));
        double RA = (darctan2((dcos(e) * dsin(L)), (dcos(L)))) / 15.0;
        RA = fixhour(RA);
        double EqT = q / 15.0 - RA;
        double[] sPosition = new double[2];
        sPosition[0] = d;
        sPosition[1] = EqT;

        return sPosition;
    }

    // compute equation of time
    private static double equationOfTime(double jd) {
        return sunPosition(jd)[1];
    }

    // compute declination angle of sun
    private static double sunDeclination(double jd) {
        return sunPosition(jd)[0];
    }

    // compute mid-day (Dhuhr, Zawal) time
    private double computeMidDay(double t) {
        double T = equationOfTime(jDate + t);
        return fixhour(12 - T);
    }

    // compute time for a given angle G
    private double computeTime(double G, double t) {

        double D = sunDeclination(jDate + t);
        double Z = computeMidDay(t);
        double Beg = -dsin(G) - dsin(D) * dsin(lat);
        double Mid = dcos(D) * dcos(lat);
        double V = darccos(Beg / Mid) / 15.0;

        return Z + (G > 90 ? -V : V);
    }

    // compute the time of Asr
    // Shafii: step=1, Hanafi: step=2
    private double computeAsr(double step, double t) {
        double D = sunDeclination(jDate + t);
        double G = -darccot(step + dtan(Math.abs(lat - D)));
        return computeTime(G, t);
    }

    // ---------------------- Misc Functions -----------------------

    // compute the difference between two times
    private static double timeDiff(double time1, double time2) {
        return fixhour(time2 - time1);
    }

    // ---------------------- Compute Prayer Times -----------------------

    // compute prayer times at given julian date
    private double[] computeTimes(double[] times) {

        double[] t = dayPortion(times);

        double Fajr = this.computeTime(180 - calcMethod.fajrAngle, t[0]);
        double Sunrise = this.computeTime(180 - 0.833, t[1]);
        double Dhuhr = this.computeMidDay(t[2]);
        double Asr = this.computeAsr(1 + asrJuristic, t[3]);
        double Sunset = this.computeTime(0.833, t[4]);
        double Maghrib = this.computeTime(calcMethod.magribVal, t[5]);
        double Isha = this.computeTime(calcMethod.ishaVal, t[6]);

        return new double[]{Fajr, Sunrise, Dhuhr, Asr, Sunset, Maghrib, Isha};

    }

    // convert double to short
    private static short floatToMinutesShort(double time) {
        if (Double.isNaN(time)) {
            return -1;
        }
        time = fixhour(time + 0.5 / 60.0); // add 0.5 minutes to round
        short hours = (short) Math.floor(time);
        short minutes = (short) Math.floor((time - hours) * 60.0);
        return (short) (minutes + hours * 60);
    }

    // compute prayer times at given julian date
    private void computeDayTimes() {
        double[] times = {5, 6, 12, 13, 18, 18, 18}; // default times

        for (int i = 1; i <= NUM_ITERATIONS; i++) {
            times = computeTimes(times);
        }

        times = adjustTimes(times);
        times = tuneTimes(times);

        this.times[FAJR] = floatToMinutesShort(times[0]);
        this.times[FAJR_IQAMA] = (short) (this.times[FAJR] + getFajrIqama());
        this.times[SUNRISE] = floatToMinutesShort(times[1]);
        this.times[DUHR] = floatToMinutesShort(times[2]);
        this.times[DUHR_IQAMA] = (short) (this.times[DUHR] + getDuhrIqama());
        this.times[ASR] = floatToMinutesShort(times[3]);
        this.times[ASR_IQAMA] = (short) (this.times[ASR] + getAsrIqama());
        this.times[SUNSET] = floatToMinutesShort(times[4]);
        this.times[MAGRIB] = floatToMinutesShort(times[5]);
        this.times[MAGRIB_IQAMA] = (short) (this.times[MAGRIB] + getMagribIqama());
        this.times[ISHA] = floatToMinutesShort(times[6]);
        this.times[ISHA_IQAMA] = (short) (this.times[ISHA] + getIshaIqama());
    }

    // adjust times in a prayer time array
    private double[] adjustTimes(double[] times) {
        for (int i = 0; i < times.length; i++) {
            times[i] += timeZone - lng / 15;
        }

        times[2] += dhuhrMinutes / 60; // Dhuhr
        if (calcMethod.magribIsMinuets) // Maghrib
            times[5] = times[4] + calcMethod.magribVal / 60;
        if (calcMethod.ishaIsMinuets) // Isha
            times[6] = times[5] + calcMethod.ishaVal / 60;

        if (adjustHighLats != NONE)
            times = adjustHighLatTimes(times);

        return times;
    }

    // adjust Fajr, Isha and Maghrib for locations in higher latitudes
    private double[] adjustHighLatTimes(double[] times) {
        double nightTime = timeDiff(times[4], times[1]); // sunset to sunrise

        double FajrDiff = nightPortion(calcMethod.fajrAngle) * nightTime;

        if (Double.isNaN(times[0]) || timeDiff(times[0], times[1]) > FajrDiff) {
            times[0] = times[1] - FajrDiff;
        }

        // Adjust Isha
        double IshaAngle = (calcMethod.ishaIsMinuets) ? calcMethod.ishaVal : 18;
        double IshaDiff = this.nightPortion(IshaAngle) * nightTime;
        if (Double.isNaN(times[6]) || timeDiff(times[4], times[6]) > IshaDiff) {
            times[6] = times[4] + IshaDiff;
        }

        // Adjust Maghrib
        double MaghribAngle = (calcMethod.magribIsMinuets) ? calcMethod.magribVal : 4;
        double MaghribDiff = nightPortion(MaghribAngle) * nightTime;
        if (Double.isNaN(times[5]) || timeDiff(times[4], times[5]) > MaghribDiff) {
            times[5] = times[4] + MaghribDiff;
        }

        return times;
    }

    // the night portion used for adjusting times in higher latitudes
    private double nightPortion(double angle) {
        double calc = 0;

        if (adjustHighLats == ANGLE_BASED)
            calc = (angle) / 60.0;
        else if (adjustHighLats == MIDNIGHT)
            calc = 0.5;
        else if (adjustHighLats == ONE_SEVENTH)
            calc = 0.14286;

        return calc;
    }

    // convert hours to day portions
    private static double[] dayPortion(double[] times) {
        for (int i = 0; i < 7; i++)
            times[i] /= 24;
        return times;
    }

    // Tune timings for adjustments
    // Set time offsets
    public void tune(int fajr, int sunrise, int duhr, int asr, int sunset, int magrib, int isha) {
        this.offsets[0] = (short) fajr;
        this.offsets[1] = (short) sunrise;
        this.offsets[2] = (short) duhr;
        this.offsets[3] = (short) asr;
        this.offsets[4] = (short) sunset;
        this.offsets[5] = (short) magrib;
        this.offsets[6] = (short) isha;
    }

    private double[] tuneTimes(double[] times) {
        for (int i = 0; i < times.length; i++) {
            times[i] = times[i] + this.offsets[i] / 60.0;
        }
        return times;
    }

    // -------------------- Interface Functions --------------------

    // setup prayer times
    public void calculateFor(int year, int month, int day, double latitude, double longitude, double tZone) {
        lat = latitude;
        lng = longitude;
        timeZone = tZone;
        jDate = julianDate(year, month, day);
        double lonDiff = longitude / (15.0 * 24.0);
        jDate = jDate - lonDiff;
        computeDayTimes();
    }

    // setup prayer times with a calendar
    public void calculateFor(Calendar cal, double latitude, double longitude, double tZone) {
        calculateFor(
                     cal.get(Calendar.YEAR),
                     cal.get(Calendar.MONTH) + 1,
                     cal.get(Calendar.DATE),
                     latitude, longitude, tZone
                     );
    }

    // setup prayer times only with a calendar
    public void calculateFor(Calendar cal) {
        calculateFor(
                     cal.get(Calendar.YEAR),
                     cal.get(Calendar.MONTH) + 1,
                     cal.get(Calendar.DATE),
                     lat, lng, timeZone
                     );
    }

    public short[] getShortTimes() {
        if (times == null)
            throw new RuntimeException("'calculateFor()' should be called first");
        return times;
    }

    public String[] getStringTimes() {
        if (times == null)
            throw new RuntimeException("'calculateFor()' should be called first");
        String[] res = new String[times.length];
        for (int i = 0; i < res.length; i++)
            res[i] = timeToString(times[i]);
        return res;
    }

    public short getShortTime(byte i) {
        if (times == null)
            throw new RuntimeException("'calculateFor()' should be called first");
        return times[i];
    }

    public String getStringTime(byte i) {
        return timeToString(getShortTime(i));
    }

    public byte getNextTime(short now) {
        for (byte i = 0; i < times.length; i++)
            if (times[i] >= now)
                return i;
        return FAJR;
    }

    public byte getNextTime2() {
        return getNextTime2(getShortTimeNow());
    }

    public byte getNextTime2(short now) {
        return closestIndex(getNextTime(now));
    }

    public byte getNextTime3(short now) {
        for (byte i : SIMPLE_TIMES_WITH_IQAMA)
            if (times[i] >= now)
                return i;
        return FAJR;
    }

    public boolean isPrayingTime(boolean orIqama) {
        short now = getShortTimeNow();
        byte next = orIqama ? getNextTime3(now) : getNextTime2(now);
        short time = times[next];
        short diff = (short) (time - now);
        return diff == 0;
    }

    public String getNextWithRemainingString() {
        short now = getShortTimeNow();
        byte n = getNextTime(now);
        byte n2 = closestIndex(n);
        return timesNames[n2] + "   " + timeToString(times[n2]) + "\n" +
            getRemainingTimeString(now, (byte) -1, n);
    }

    public String[] getNextWithRemainingTwoString() {
        short now = getShortTimeNow();
        byte n = getNextTime(now);
        byte n2 = closestIndex(n);
        return new String[]{
            timesNames[n2] + "   " + timeToString(times[n2]),
            getRemainingTimeString(now, (byte) -1, n)
        };
    }

    public String getSmallNextRemaining() {
        short now = getShortTimeNow();
        return getSmallNextRemaining(now, getNextTime(now));
    }

    public String getOneLineSmallNextRemaining(short now, byte next) {
        short time = times[next];
        short diff = (short) (time - now);
        boolean isNow = diff == 0;
        if (isNow) {
            return timesNames[next];
        }
        if (diff < 0) {
            diff = (short) -diff;
            if (next == FAJR) {
                diff = (short) (time + (24 * 60) - now);
            }
        }
        return timeToString(diff, TIME_24);
    }

    public String getSmallNextRemaining(short now, byte next) {
        short time = times[next];
        short diff = (short) (time - now);
        boolean isNow = diff == 0;
        if (isNow) {
            return timesNames[next];
        }
        String s;
        if (diff < 0) {
            diff = (short) -diff;
            if (next == FAJR) {
                diff = (short) (time + (24 * 60) - now);
                s = strRemaining;
            } else {
                s = strPassed;
            }
        } else {
            s = strRemaining;
        }
        if (next == FAJR_IQAMA || next == DUHR_IQAMA || next == ASR_IQAMA ||
            next == MAGRIB_IQAMA || next == ISHA_IQAMA) {
            s = strIqama;
        }
        return s + "\n" + timeToString(diff, TIME_24);
    }

    public String getRemainingTimeString() {
        short now = calToShortTime(Calendar.getInstance());
        return getRemainingTimeString(now, (byte) -1, getNextTime(now));
    }

    public String getRemainingTimeString(short now) {
        return getRemainingTimeString(now, (byte) -1, getNextTime(now));
    }

    public String getRemainingTimeString(short now, byte i) {
        return getRemainingTimeString(now, i, getNextTime(now));
    }

    public String getRemainingTimeString(short now, byte i, byte next) {
        if (i == -1) i = next;
        short time = times[i];
        short diff = (short) (time - now);
        boolean isNow = diff == 0;
        if (isNow) {
            return strItsTimeFor + " " + timesNames[i];
        }
        String s;
        boolean passed = diff < 0;
        if (passed) {
            diff = (short) -diff;
            if (i == FAJR && next == FAJR) {
                diff = (short) (time + (24 * 60) - now);
                s = strRemaining;
            } else {
                s = strPassed;
            }
        } else {
            s = strRemaining;
        }

        short h = (short) (diff / 60);
        short m = (short) (diff % 60);
        String hS = Short.toString(h);
        String mS = Short.toString(m);
        String t;
        if (isAr) {
            switch (h) {
            case 1:
                hS = strHour;
                break;
            case 2:
                hS = str2Hours;
                break;
            default:
                hS += " ";
                if (h > 10)
                    hS += strHour;
                else
                    hS += strHours;
            }
            switch (m) {
            case 1:
                mS = strMinute;
                break;
            case 2:
                mS = str2Minutes;
                break;
            default:
                mS += " ";
                if (m > 10)
                    mS += strMinute;
                else
                    mS += strMinutes;
            }
            if (h == 0) {
                t = mS;
            } else if (m == 0) {
                t = hS;
            } else {
                t = hS + strAnd + mS;
            }
        } else {
            if (h == 0) {
                t = mS + " " + strMinutes;
            } else if (m == 0) {
                t = hS + " " + strHours;
            } else {
                t = hS + " " + strHours + strAnd + mS + " " + strMinutes;
            }
        }

        s += " " + t;
        if (i == FAJR_IQAMA || i == DUHR_IQAMA || i == ASR_IQAMA ||
            i == MAGRIB_IQAMA || i == ISHA_IQAMA) {
            s += " " + (passed ? strFromIqama : strToIqama);
        }
        return s;
    }

    public void initStrings() {
        if (isAr) {
            timesNames = new String[]{
                "الفجر",
                "إقامة الفجر",
                "الشروق",
                "الظهر",
                "إقامة الظهر",
                "العصر",
                "إقامة العصر",
                "المغرب",
                "المغرب",
                "إقامة المغرب",
                "العشاء",
                "إقامة العشاء"
            };
            strRemaining = "المتبقي";
            strPassed = "مرت";
            strToPray = "لصلاة";
            strIqama = "الإقامة";
            strToIqama = "للإقامة";
            strFromIqama = "من الإقامة";
            strItsTimeFor = "حان وقت";
            strHour = "ساعة";
            strHours = "ساعات";
            str2Hours = "ساعتان";
            strMinute = "دقيقة";
            strMinutes = "دقائق";
            str2Minutes = "دقيقتان";
            strAnd = " و ";
        } else {
            timesNames = new String[]{
                "Fajr",
                "Fajr iqama",
                "Sunrise",
                "Duhr",
                "Duhr iqama",
                "Asr",
                "Asr iqama",
                "Magrib",
                "Magrib",
                "Magrib iqama",
                "Isha",
                "Isha iqama"
            };
            strRemaining = "Remaining";
            strPassed = "Passed";
            strToPray = "to";
            strIqama = "iqama";
            strToIqama = "to iqama";
            strFromIqama = "from iqama";
            strItsTimeFor = "It's time for";
            strHour = "hr";
            strHours = strHour;
            str2Hours = strHour;
            strMinute = "min";
            strMinutes = strMinute;
            str2Minutes = strMinute;
            strAnd = " and ";
        }
    }

    public String timeToString(Calendar cal) {
        return timeToString(
                            (short) cal.get(Calendar.HOUR_OF_DAY), (short) cal.get(Calendar.MINUTE),
                            this.timeFormat, this.isAr
                            );
    }

    public String timeToString(short time) {
        return timeToString(time, this.timeFormat, this.isAr);
    }

    public String timeToString(short time, byte timeFormat) {
        return timeToString(time, timeFormat, this.isAr);
    }

    public static String timeToString(short time, byte timeFormat, boolean isAr) {
        return timeToString((short) (time / 60), (short) (time % 60), timeFormat, isAr);
    }

    public static String timeToString(short hours, short minutes, byte timeFormat, boolean isAr) {
        String result;
        switch (timeFormat) {
        case TIME_24:
            if ((hours >= 0 && hours <= 9) && (minutes >= 0 && minutes <= 9)) {
                result = "0" + hours + ":0" + minutes;
            } else if ((hours >= 0 && hours <= 9)) {
                result = "0" + hours + ":" + minutes;
            } else if ((minutes >= 0 && minutes <= 9)) {
                result = hours + ":0" + minutes;
            } else {
                result = hours + ":" + minutes;
            }
            break;
        case TIME_12:
            String suffix;
            if (isAr) {
                suffix = hours >= 12 ? "م" : "ص";
            } else {
                suffix = hours >= 12 ? "PM" : "AM";
            }
            hours = (short) ((((hours + 12) - 1) % (12)) + 1);
            if ((hours >= 0 && hours <= 9) && (minutes >= 0 && minutes <= 9)) {
                result = "0" + hours + ":0" + minutes + " "
                    + suffix;
            } else if ((hours >= 0 && hours <= 9)) {
                result = "0" + hours + ":" + minutes + " " + suffix;
            } else if ((minutes >= 0 && minutes <= 9)) {
                result = hours + ":0" + minutes + " " + suffix;
            } else {
                result = hours + ":" + minutes + " " + suffix;
            }
            break;
        case TIME_12_NS:
            hours = (short) ((((hours + 12) - 1) % (12)) + 1);
            if ((hours >= 0 && hours <= 9) && (minutes >= 0 && minutes <= 9)) {
                result = "0" + hours + ":0" + minutes;
            } else if ((hours >= 0 && hours <= 9)) {
                result = "0" + hours + ":" + minutes;
            } else if ((minutes >= 0 && minutes <= 9)) {
                result = hours + ":0" + minutes;
            } else {
                result = hours + ":" + minutes;
            }
            break;
        default:
            throw new RuntimeException("Unknown time format");
        }
        return result;
    }

    // set custom values for calculation parameters
    public void setCustomMethod(Method method) {
        calcMethod = CUSTOM.from(method);
    }

    // set the angle for calculating Fajr
    public void setFajrAngle(float angle) {
        calcMethod = CUSTOM;
        CUSTOM.fajrAngle = angle;
    }

    // set the angle for calculating Maghrib
    public void setMaghribAngle(float angle) {
        calcMethod = CUSTOM;
        CUSTOM.magribIsMinuets = false;
        CUSTOM.magribVal = angle;
    }

    // set the angle for calculating Isha
    public void setIshaAngle(float angle) {
        calcMethod = CUSTOM;
        CUSTOM.ishaIsMinuets = false;
        CUSTOM.ishaVal = angle;
    }

    // set the minutes after Sunset for calculating Maghrib
    public void setMaghribMinutes(float minutes) {
        calcMethod = CUSTOM;
        CUSTOM.magribIsMinuets = true;
        CUSTOM.magribVal = minutes;
    }

    // set the minutes after Maghrib for calculating Isha
    public void setIshaMinutes(float minutes) {
        calcMethod = CUSTOM;
        CUSTOM.ishaIsMinuets = true;
        CUSTOM.ishaVal = minutes;
    }

    public void setFajrIqama(short minutes) {
        iqama[0] = minutes;
    }

    public void setDuhrIqama(short minutes) {
        iqama[1] = minutes;
    }

    public void setAsrIqama(short minutes) {
        iqama[2] = minutes;
    }

    public void setMagribIqama(short minutes) {
        iqama[3] = minutes;
    }

    public void setIshaIqama(short minutes) {
        iqama[4] = minutes;
    }

    public short getFajrIqama() {
        return iqama[0];
    }

    public short getDuhrIqama() {
        return iqama[1];
    }

    public short getAsrIqama() {
        return iqama[2];
    }

    public short getMagribIqama() {
        return iqama[3];
    }

    public short getIshaIqama() {
        return iqama[4];
    }

    public static short calToShortTime(Calendar cal) {
        return (short) (cal.get(Calendar.HOUR_OF_DAY) * 60 + cal.get(Calendar.MINUTE));
    }

    public static short getShortTimeNow() {
        return calToShortTime(Calendar.getInstance());
    }

    public static byte simpleIndices(byte i) {
        switch (i) {
        case FAJR:
        case FAJR_IQAMA:
            return 0;
        case SUNRISE:
            return 1;
        case DUHR:
        case DUHR_IQAMA:
            return 2;
        case ASR:
        case ASR_IQAMA:
            return 3;
        case SUNSET:
        case MAGRIB:
        case MAGRIB_IQAMA:
            return 4;
        case ISHA:
        case ISHA_IQAMA:
            return 5;
        default:
            throw new IllegalArgumentException(
                                               "Unknown input to simpleIndices(" + i + ")"
                                               );
        }
    }

    public static byte normalIndices(int simple) {
        switch (simple) {
        case 0:
            return FAJR;
        case 1:
            return SUNRISE;
        case 2:
            return DUHR;
        case 3:
            return ASR;
        case 4:
            return MAGRIB;
        case 5:
            return ISHA;
        default:
            throw new IllegalArgumentException(
                                               "Unknown input to normalIndices(" + simple + ")"
                                               );
        }
    }

    public static byte closestIndex(byte i) {
        switch (i) {
        case FAJR:
        case FAJR_IQAMA:
            return FAJR;
        case SUNRISE:
            return SUNRISE;
        case DUHR:
        case DUHR_IQAMA:
            return DUHR;
        case ASR:
        case ASR_IQAMA:
            return ASR;
        case SUNSET:
        case MAGRIB:
        case MAGRIB_IQAMA:
            return MAGRIB;
        case ISHA:
        case ISHA_IQAMA:
            return ISHA;
        default:
            throw new IllegalArgumentException(
                                               "Unknown input to closestIndex(" + i + ")"
                                               );
        }
    }

    public static String getTimesNameSimpleLowerCase(int i) {
        switch (i) {
        case 0:
            return "fajr";
        case 1:
            return "sunrise";
        case 2:
            return "duhr";
        case 3:
            return "asr";
        case 4:
            return "magrib";
        case 5:
            return "isha";
        }
        return "error";
    }

    public Pt from(Pt from) {
        this.timeFormat = from.timeFormat;
        this.isAr = from.isAr;
        this.calcMethod = from.calcMethod;
        this.asrJuristic = from.asrJuristic;
        this.adjustHighLats = from.adjustHighLats;
        this.lat = from.lat;
        this.lng = from.lng;
        this.timeZone = from.timeZone;
        System.arraycopy(from.offsets, 0, this.offsets, 0, from.offsets.length);
        System.arraycopy(from.iqama, 0, this.iqama, 0, from.iqama.length);
        this.times = new short[from.times.length];
        System.arraycopy(from.times, 0, this.times, 0, from.times.length);
        this.initStrings();
        return this;
    }

    @Override
    public String toString() {
        return "Pt{" +
            "strRemaining='" + strRemaining + '\'' +
            ", lat=" + lat +
            ", lng=" + lng +
            ", calcMethod=" + calcMethod +
            ", asrJuristic=" + asrJuristic +
            ", adjustHighLats=" + adjustHighLats +
            ", timeFormat=" + timeFormat +
            ", isAr=" + isAr +
            ", timeZone=" + timeZone +
            ", times=" + Arrays.toString(times) +
            ", offsets=" + Arrays.toString(offsets) +
            ", iqama=" + Arrays.toString(iqama) +
            '}';
    }

    public static short createTime(int h, int m) {
        return (short) (h * 60 + m);
    }

    // --------------------- Main --------------------------------

    public static void main(String[] args) {

        boolean argos = false;
        boolean next = false;

        if (args.length > 0) {
            if (args[0].equals("argos")) argos = true;
            else if (args[0].equals("n")) next = true;
        }

        Pt pt = new Pt();

        pt.timeFormat = TIME_12;
        pt.isAr = argos;
        pt.calcMethod = MAKKAH;
        pt.asrJuristic = SHAFII;
        pt.adjustHighLats = ANGLE_BASED;
        pt.tune(0, 0, 0, 0, 0, 0, 0);

        Calendar cal = Calendar.getInstance();

        pt.calculateFor(cal, 25.2896752, 51.4975578, 3);
        pt.initStrings();
        short[] times = pt.getShortTimes();

        short now = Pt.calToShortTime(cal); //Pt.createTime(19, 33);
        byte nxt = pt.getNextTime2(now);
        byte realNxt = pt.getNextTime(now);

        if (next || argos) {
            System.out.print(pt.getOneLineSmallNextRemaining(now, realNxt));
        }

        if (argos) {
            System.out.println(" | image='" + ICON + "'");
            System.out.println("---");
        }

        if (argos) {
            String font = " | font=monospace";

            for (byte i : SIMPLE_TIMES) {
                if (i == nxt) {
                    if (i != FAJR) System.out.println("---");
                    System.out.println(pt.timesNames[i] + "\t\t" + pt.getStringTime(i) + font);
                    System.out.println(pt.getRemainingTimeString(now, (byte) -1, realNxt) + font);
                    if (i != ISHA) System.out.println("---");
                } else {
                    System.out.println(pt.timesNames[i] + "\t\t" + pt.getStringTime(i) + font);
                    System.out.println("--" + pt.getRemainingTimeString(now, i, realNxt) + font);
                }
            }
        } else if (!next) {
            for (byte i : SIMPLE_TIMES) {
                System.out.println(pt.timesNames[i] + "\t\t" + pt.getStringTime(i));
                if (i == nxt) {
                    System.out.println(pt.getRemainingTimeString(now, (byte) -1, realNxt));
                }
            }
        }

    }

}
