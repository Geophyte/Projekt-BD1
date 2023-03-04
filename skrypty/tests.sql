-- Test złączenia tabel customers i accounts po kolumnie customer_id
SELECT first_name, last_name, email, phone_number, account_number, balance
FROM customers JOIN accounts ON customers.customer_id = accounts.customer_id;

-- Test filtrowania transakcji po typie transakcji i dacie
SELECT transaction_id, account_number, transaction_date, amount
FROM transactions
WHERE transaction_type = 'withdraw' AND transaction_date > '2022-01-01';

-- Test grupowania transakcji po numerze konta i sumowania kwot
SELECT account_number, SUM(amount) as total_amount
FROM transactions
GROUP BY account_number;

-- Test złączenia tabel transactions i accounts po kolumnie account_number
-- z filtrowaniem po dacie transakcji i wyświetleniem imienia i nazwiska klienta oraz saldo konta
SELECT a.first_name, a.last_name, t.account_number, t.transaction_date, t.amount, ac.balance
FROM transactions t JOIN accounts ac ON t.account_number = ac.account_number
JOIN customers a ON a.customer_id = ac.customer_id
WHERE t.transaction_date > '2022-01-01';

-- Test złączenia tabel customers, addresses, accounts, transactions
-- z filtrowaniem po mieście i sumowaniem kwot transakcji dla każdego klienta
SELECT first_name, last_name, SUM(amount) as total_amount, city
FROM customers JOIN addresses ON customers.customer_id = addresses.customer_id
JOIN accounts ON customers.customer_id = accounts.customer_id
JOIN transactions ON transactions.account_number = accounts.account_number
GROUP BY first_name, last_name, city
ORDER BY total_amount;

-- Test działania wyzwalacza dla transakcji
DECLARE
    v_account_number NUMBER;
BEGIN
    add_customer('John', 'Doe', 555123456, 'johndoe@email.com', 'password1', 'Main Street', 'New York', 'USA', 12345);
    v_account_number := add_account(1, SYSDATE, 1000, 'daily', 100);

    -- Sprawdzamy bilans konta przed transakcją
    SELECT balance FROM accounts WHERE account_number = v_account_number;

    -- Dodajemy tranzakcję
    INSERT INTO transactions (transaction_id, account_number, transaction_date, transaction_type, amount)
    VALUES (transactions_seq.NEXTVAL, v_account_number, SYSDATE, 'withdraw', 100);

    -- Sprawdzamy bilans konta po transakcji
    SELECT balance  FROM accounts WHERE account_number = v_account_number;
end;

-- Test działania wyzwalacza dla limitów
DECLARE
    v_account_number NUMBER;
BEGIN
    add_customer('John', 'Doe', 555123456, 'johndoe@email.com', 'password1', 'Main Street', 'New York', 'USA', 12345);
    v_account_number := add_account(1, SYSDATE, 1000, 'daily', 100);

    -- Sprawdzamy bilans konta przed transakcją
    SELECT account_number, action_type, old_value, new_value  FROM account_history WHERE account_number = v_account_number;

    -- Zmieniamy limit
    UPDATE limits SET limit_type = 'monthly', amount = 1000 WHERE account_number = v_account_number;

    -- Sprawdzamy bilans konta przed transakcją
    SELECT account_number, action_type, old_value, new_value  FROM account_history WHERE account_number = v_account_number;
end;