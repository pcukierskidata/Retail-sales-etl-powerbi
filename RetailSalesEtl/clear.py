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

#print(df_customers.isna().sum())
#print(df_sales.isna().sum())
#print(df_products.isna().sum())

df_customers['City'] = df_customers['City'].fillna('Nieznane')
df_customers['RegistrationDate'] = df_customers['RegistrationDate'].fillna(datetime.date.today())

# 2. usunięcie duplikatów
df_customers = df_customers.drop_duplicates()
df_sales = df_sales.drop_duplicates()
df_products = df_products.drop_duplicates()

# 3. sprawdzenie i ewentualna konwersja typów danych

# print(df_sales.dtypes)
# print(df_customers.dtypes)
# print(df_products.dtypes)

df_sales['SaleDate'] = pd.to_datetime(df_sales['SaleDate'])
df_customers['RegistrationDate'] = pd.to_datetime(df_customers['RegistrationDate'])

# 4. sprawdzenie zakresów i wartości

# print(df_sales[df_sales['UnitPrice'] <= 0])
# print(df_sales[df_sales['Quantity'] <= 0])

print(df_sales['UnitPrice'].describe())
print(df_sales['Quantity'].describe())

# 5. połączenie danych do analizy

# 6. dodanie kolumn pomocniczych

# sprawdzenie efektu końcowego



