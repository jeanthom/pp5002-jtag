# PP5002 RTC test

halt
wait_halt 2000

# Reset RTC to 0s
mww 0xcf001114 0

# Wait for 10s
sleep 10000
set rtc_sec [expr {"0x[lindex [mdw 0xcf001114] 1]"}]

# Reset RTC to 59s
mww 0xcf001114 59

# Wait for 2s
sleep 2000
set rtc_min [expr {"0x[lindex [mdw 0xcf001114] 1]"}]

# Reset RTC to 59min 59s
mww 0xcf001114 0x00003b3b

# Wait for 2s
sleep 2000
set rtc_hour [expr {"0x[lindex [mdw 0xcf001114] 1]"}]

# Reset RTC to 23h 59min 59s
mww 0xcf001114 0x00173b3b

# Wait for 2s
sleep 2000
set rtc_day [expr {"0x[lindex [mdw 0xcf001114] 1]"}]

resume

# Check seconds value is 9 <= x <= 11
if {$rtc_sec < 9 || $rtc_sec > 11} {
	error "RTC FAIL: got $rtc_sec, expected 9..11"
}
echo "RTC SECONDS OK"

# Check minute value (bits 13:8) is 1
if {(($rtc_min >> 8) & 0x3f) != 1} {
	error "RTC FAIL: got $rtc_min, expected minutes = 1"
}
echo "RTC MINUTES OK"

# Check hour value (bits 20:16) is 1
if {(($rtc_hour >> 16) & 0x1f) != 1} {
	error "RTC FAIL: got $rtc_hour, expected hours = 1"
}
echo "RTC HOURS OK"

# Check day value (bits 29:24) is 1
if {(($rtc_day >> 24) & 0x3f) != 1} {
	error "RTC FAIL: got $rtc_day, expected days = 1"
}
echo "RTC DAYS OK"
