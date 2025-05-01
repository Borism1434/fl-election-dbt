# db.py
from sqlalchemy import create_engine, text
import os
import pandas as pd
from dotenv import load_dotenv

# Load environment variables from .env
load_dotenv()

# Centralized config dictionary
DB_CONFIG = {
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "host": os.getenv("DB_HOST"),
    "port": os.getenv("DB_PORT"),
    "database": os.getenv("DB_NAME"),
}

# Create and expose SQLAlchemy engine
def get_engine():
    conn_str = (
        f"postgresql+psycopg2://{DB_CONFIG['user']}:{DB_CONFIG['password']}@"
        f"{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['database']}"
    )
    return create_engine(conn_str)

# Reusable query function
def run_query(query: str) -> pd.DataFrame:
    engine = get_engine()
    with engine.connect() as conn:
        return pd.read_sql(query, conn)
    

def execute_sql(sql: str):
    engine = get_engine()
    with engine.begin() as conn:  # begin() automatically commits or rolls back
        conn.execute(text(sql))