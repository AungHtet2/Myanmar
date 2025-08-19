import pandas as pd
import os

# Paths
csv_file = r"D:\DA_Portfolio\Myanmar\csv\MMR_RTFP_mkt_2008_2025-08-11.csv"
sql_file = r"D:\DA_Portfolio\Myanmar\sql\MMR_RTFP_mkt_2008_2025-08-11.sql"
table_name = "myanmar_food_prices"

# Ensure output directory exists
os.makedirs(os.path.dirname(sql_file), exist_ok=True)

# Read CSV
df = pd.read_csv(csv_file)

# Convert 'Jan 2008', 'Jun 2025' style strings to proper dates
for col in ['start_dense_data', 'last_survey_point']:
    if col in df.columns:
        df[col] = pd.to_datetime(df[col], format='%b %Y', errors='coerce').dt.strftime('%Y-%m-%d')

# Function to escape values for SQL
def sql_escape(val, col_name=None):
    if pd.isna(val):
        return "NULL"
    elif col_name == "spatially_interpolated":
        # Convert 0/1 or strings '0'/'1' to TRUE/FALSE
        return "TRUE" if str(val) in ["1", "True", "true"] else "FALSE"
    elif isinstance(val, str):
        return "'" + val.replace("'", "''") + "'"
    else:
        return str(val)

# Write SQL file
with open(sql_file, "w", encoding="utf-8") as f:
    # Write INSERT statements
    for _, row in df.iterrows():
        values = [sql_escape(row[col], col) for col in df.columns]
        insert_sql = f"INSERT INTO {table_name} ({', '.join(df.columns)}) VALUES ({', '.join(values)});\n"
        f.write(insert_sql)

print(f"✅ SQL file created: {sql_file}")



# \i 'D:/DA_Portfolio/Myanmar/sql/MMR_RTFP_mkt_2008_2025-08-11.sql'
