-- Tworzenie sekwencji dla klientów
CREATE SEQUENCE customers_seq START WITH 1;

-- Tworzenie sekwencji dla kont
CREATE SEQUENCE accounts_seq
START WITH 100000
INCREMENT BY 1
MAXVALUE 999999;

-- Tworzenie sekwencji dla transakcji
CREATE SEQUENCE transactions_seq START WITH 1;

-- Tworzenie sekwencji dla kart
CREATE SEQUENCE cards_seq
START WITH 1111222233334444
INCREMENT BY 123
MAXVALUE 9999999999999999;

-- Tworzenie sekwencji dla limitów
CREATE SEQUENCE limits_seq START WITH 1;

-- Tworzenie sekwencji dla adresów
CREATE SEQUENCE addresses_seq START WITH 1;

-- Tworzenie sekwencji dla komunikacji klient-bank
CREATE SEQUENCE customer_communication_seq START WITH 1;

-- Tworzenie sekwencji dla historii
CREATE SEQUENCE account_history_seq START WITH 1;

-- Tworzenie funkcji do dodawania danych
CREATE OR REPLACE FUNCTION add_account(
    p_customer_id NUMBER,
    p_create_date DATE,
    p_balance NUMBER,
    p_limit_type VARCHAR2,
    p_limit_amount NUMBER)
RETURN NUMBER
AS
    v_account_number NUMBER;
BEGIN
    SELECT accounts_seq.NEXTVAL INTO v_account_number FROM DUAL;

    INSERT INTO accounts (account_number, customer_id, balance)
    VALUES (v_account_number, p_customer_id, 0);

    INSERT INTO transactions (transaction_id, account_number, transaction_date, transaction_type, amount)
    VALUES (transactions_seq.NEXTVAL, v_account_number, p_create_date, 'deposit', p_balance);

    INSERT INTO limits (limit_id, account_number, limit_type, amount)
    VALUES (limits_seq.NEXTVAL, v_account_number, p_limit_type, p_limit_amount);

    INSERT INTO account_history (history_id, account_number, action_type, action_date, old_value, new_value)
    VALUES (account_history_seq.NEXTVAL, v_account_number, 'create_account', p_create_date, NULL, NULL);

    INSERT INTO account_history (history_id, account_number, action_type, action_date, old_value, new_value)
    VALUES (account_history_seq.NEXTVAL, v_account_number, 'change_limit_amount', p_create_date, NULL, p_limit_amount);

    INSERT INTO account_history (history_id, account_number, action_type, action_date, old_value, new_value)
    VALUES (account_history_seq.NEXTVAL, v_account_number, 'change_limit_type', p_create_date, NULL, p_limit_type);

    RETURN v_account_number;
end;

CREATE OR REPLACE FUNCTION add_card(
    p_account_number NUMBER,
    p_create_date DATE)
RETURN NUMBER
AS
    v_card_number NUMBER;
    v_expiry_date DATE;
BEGIN
    SELECT cards_seq.NEXTVAL INTO v_card_number FROM DUAL;
    SELECT p_create_date + INTERVAL '2' YEAR INTO v_expiry_date FROM DUAL;

    INSERT INTO cards (card_number, account_number, expiry_date)
    VALUES (v_card_number, p_account_number, v_expiry_date);

    INSERT INTO account_history(history_id, account_number, action_type, action_date, old_value, new_value)
    VALUES (account_history_seq.NEXTVAL, p_account_number, 'create_card', p_create_date, NULL, NULL);

    RETURN v_card_number;
end;

CREATE OR REPLACE PROCEDURE add_transaction(
    p_account_number NUMBER,
    p_create_date DATE,
    p_type VARCHAR2,
    p_amount NUMBER)
AS
BEGIN
    INSERT INTO transactions (transaction_id, account_number, transaction_date, transaction_type, amount)
    VALUES (transactions_seq.NEXTVAL, p_account_number, p_create_date, p_type, p_amount);
end;

CREATE OR REPLACE PROCEDURE add_customer(
    p_first_name VARCHAR2,
    p_last_name VARCHAR2,
    p_phone_number NUMBER,
    p_email VARCHAR2,
    p_password VARCHAR2,
    p_street VARCHAR2,
    p_city VARCHAR2,
    p_country VARCHAR2,
    p_postal_code NUMBER
)
AS
    v_customer_id NUMBER;
BEGIN
    SELECT customers_seq.NEXTVAL INTO v_customer_id FROM DUAL;

    INSERT INTO customers (customer_id, first_name, last_name, phone_number, email, password)
    VALUES (v_customer_id, p_first_name, p_last_name, p_phone_number, p_email, p_password);

    INSERT INTO addresses (address_id, customer_id, street, city, country, postal_code)
    VALUES (addresses_seq.NEXTVAL, v_customer_id, p_street, p_city, p_country, p_postal_code);
end;

CREATE OR REPLACE PROCEDURE add_customer_communication(
    p_customer_id NUMBER,
    p_communication_type VARCHAR2,
    p_communication_date DATE,
    p_description VARCHAR2
)
AS
BEGIN
    INSERT INTO customer_communication (customer_communication_id, customer_id, communication_type, communication_date, description)
    VALUES (customer_communication_seq.NEXTVAL, p_customer_id, p_communication_type, p_communication_date, p_description);
end;

-- Tworzenie wyzwalaczy
CREATE OR REPLACE TRIGGER trg_update_account_balance
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    IF :new.transaction_type LIKE 'withdraw' THEN
        UPDATE accounts
        SET balance = balance - :new.amount
        WHERE account_number = :new.account_number;
    else
        UPDATE accounts
        SET balance = balance + :new.amount
        WHERE account_number = :new.account_number;
    end if;
END;

CREATE OR REPLACE TRIGGER trg_update_limit_history
AFTER UPDATE ON limits
FOR EACH ROW
BEGIN
    IF :new.account_number = :old.account_number THEN
        IF :new.amount != :old.amount THEN
            INSERT INTO account_history (history_id, account_number, action_type, action_date, old_value, new_value)
            VALUES (account_history_seq.NEXTVAL, :new.account_number, 'change_limit_amount', SYSDATE, :old.amount, :new.amount);
        end if;
        IF :new.limit_type != :old.limit_type THEN
            INSERT INTO account_history (history_id, account_number, action_type, action_date, old_value, new_value)
            VALUES (account_history_seq.NEXTVAL, :new.account_number, 'change_limit_type', SYSDATE, :old.limit_type, :new.limit_type);
        end if;
    end if;
END;