import sqlite3
from datetime import datetime

conn = sqlite3.connect('/home/ndkilla/memory_drum.db')
c = conn.cursor()
c.execute("SELECT COUNT(*), MAX(timestamp) FROM entries")
count, latest = c.fetchone()
now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
print(f"Drum entries: {count} | Latest: {latest or 'None'} | open @ {now} | E8 bloom active")
conn.close()
