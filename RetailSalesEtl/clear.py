import pandas as pd
import pyodbc
import datetime

conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=PCUKIE\\SQLEXPRESS;'
    'DATABASE=PowerDatabase;'
    'Trusted_Connection=yes;'
)

df_sales = pd.read_sql("SELECT * FROM Sales", conn)
df_customers = pd.read_sql("SELECT * FROM Customers", conn)
df_products = pd.read_sql("SELECT * FROM Products", conn)

# 1. sprawdzenie i uzupełnienie braków w danych
df_customers['City'] = df_customers['City'].fillna('Nieznane')
df_customers['RegistrationDate'] = df_customers['RegistrationDate'].fillna(datetime.date.today())

# 2. usunięcie duplikatów
df_customers = df_customers.drop_duplicates()
df_sales = df_sales.drop_duplicates()
df_products = df_products.drop_duplicates()

# 3. sprawdzenie i ewentualna konwersja typów danych
df_sales['SaleDate'] = pd.to_datetime(df_sales['SaleDate'])
df_customers['RegistrationDate'] = pd.to_datetime(df_customers['RegistrationDate'])

# 4. sprawdzenie zakresów i wartości
from datetime import datetime
today = pd.to_datetime(datetime.today())

bad_prices = df_sales[df_sales['UnitPrices'] <= 0]
bad_quantities = df_sales[df_sales['Quantity'] <= 0]

df_customers['RegistrationDate'] = pd.to_datetime(df_customers['RegistrationDate'], errors='coerce')
bad_registration_dates = df_customers[df_customers['RegistrationDate'].isna()]
future_registration_dates = df_customers[df_customers['RegistrationDate'] > today]

print("Found invalid data")
if not bad_prices.empty:
    print("Rows with invalid UnitPrice:")
    print(bad_prices)
    df_sales = df_sales[df_sales['UnitPrice'] > 0]
if not bad_quantities.empty:
    print("Rows with invalid Quantity:")
    print(bad_quantities)
    df_sales = df_sales[df_sales['Quantity'] > 0]
if not bad_registration_dates.empty or not future_registration_dates.empty:
    print("Rows with invalid RegistrationDate:")
    print(bad_registration_dates)
    print(future_registration_dates)
    df_customers = df_customers[
        (df_customers['RegistrationDate'].notna()) &
        (df_customers['RegistrationDate'] <= pd.Timestamp.today())
    ]

# 5. połączenie danych do analizy

# 6. dodanie kolumn pomocniczych

# sprawdzenie efektu końcowego
