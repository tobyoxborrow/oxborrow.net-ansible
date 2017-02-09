#!/usr/bin/env python
"""
Recent Website Hits Counter
"""

import re

from datetime import datetime, timedelta

TODAY = datetime.now()
LAST_WEEK = TODAY - timedelta(days=8)

MONTHS = {'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
          'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 0, 'Nov': 11, 'Dec': 12}


def main():
    """main"""

    # example log line:
    # 123.202.207.182 - - [21/Jul/2015:13:16:04 -0400] "GET / HTTP/1.1" 200 396 "-"
    # "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko)
    # Chrome/43.0.2357.134 Safari/537.36"

    rfh = open('/var/log/nginx/access.log', 'r')
    found_start = False
    counter = 0
    for line in rfh:
        if found_start:
            if '" 200 ' in line:
                counter += 1
            continue

        # skip a lot of lines without needing to compare the date in detail
        if '" 200 ' not in line:
            continue

        matches = re.search(r'^[^\[]+\[([0-3][0-9])/([A-Sa-v]{3})/(20[0-9]{2})', line)
        if not matches:
            continue

        year = int(matches.group(3))
        month = int(MONTHS[matches.group(2)])
        day = int(matches.group(1))

        line_date = datetime(year, month, day)

        if line_date > LAST_WEEK:
            found_start = True
            continue

    wfh = open('/var/run/recent_hits', 'w')
    wfh.write('Website hits in the last 7 days: %s\n' % counter)


if __name__ == '__main__':
    main()
