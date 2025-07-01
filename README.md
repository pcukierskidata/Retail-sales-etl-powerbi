# Retail-sales-etl-powerbi
Technologie: SQL Server · Python (pandas) · Power BI

Projekt typu end-to-end, który symuluje realistyczny proces pracy z danymi sprzedażowymi:
od surowych danych w SQL Server, przez czyszczenie i eksplorację w Pythonie, po wizualizację wyników w Power BI.

## Zakres projektu

🗃️ Generowanie danych w SQL Server (klienci, produkty, sprzedaż) — z celowymi błędami i brakami w danych

🧼 Czyszczenie danych w Pythonie (pandas):
- standaryzacja miast ('warszawa', 'POZNAŃ', 'Gdańsk ' → 'Warszawa', 'Poznań', 'Gdańsk')
- uzupełnianie braków (NaN w City, RegistrationDate)
- wykrywanie i obsługa duplikatów
- filtrowanie błędnych dat (np. rejestracja w przyszłości)

📊 Analiza i wizualizacja w Power BI:
- sprzedaż wg miast, kategorii, klientów
- średnia wartość zamówienia, liczba transakcji, rozkład produktów
- trendy czasowe (ostatnie 12 miesięcy)
