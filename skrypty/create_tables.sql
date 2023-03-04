-- Tabela klientów
CREATE TABLE customers (
    customer_id NUMBER(10) PRIMARY KEY,
    first_name VARCHAR2(255) NOT NULL,
    last_name VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) NOT NULL,
    phone_number NUMBER(9) NOT NULL,
    password VARCHAR2(255) NOT NULL
);

-- Tabela kont
CREATE TABLE accounts (
    account_number NUMBER(10) PRIMARY KEY, -- zawsze 6 cyforwa liczba
    customer_id NUMBER(10) NOT NULL,
    balance NUMBER(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Tabela transakcji
CREATE TABLE transactions (
    transaction_id NUMBER(10) PRIMARY KEY,
    account_number NUMBER(10) NOT NULL,
    transaction_date DATE NOT NULL,
    transaction_type VARCHAR2(255) NOT NULL, -- withdraw lub deposit
    amount NUMBER(10, 2) NOT NULL,
    FOREIGN KEY (account_number) REFERENCES accounts(account_number)
);

-- Tabela kart
CREATE TABLE cards (
    card_number NUMBER(16) PRIMARY KEY, -- zawsze 16 cyforwa liczba
    account_number NUMBER(10) NOT NULL,
    expiry_date DATE NOT NULL,
    FOREIGN KEY (account_number) REFERENCES accounts(account_number)
);

-- Tabela limitów
CREATE TABLE limits (
    limit_id NUMBER(10) PRIMARY KEY,
    account_number NUMBER(10) NOT NULL,
    limit_type VARCHAR2(255) NOT NULL, -- daily lub monthly
    amount NUMBER(10, 2) NOT NULL,
    FOREIGN KEY (account_number) REFERENCES accounts(account_number)
);

-- Tabela adresów
CREATE TABLE addresses (
    address_id NUMBER(10) PRIMARY KEY,
    customer_id NUMBER(10) NOT NULL,
    street VARCHAR2(255) NOT NULL,
    city VARCHAR2(255) NOT NULL,
    country VARCHAR2(255) NOT NULL,
    postal_code NUMBER(10) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Tabela komunikacji klient-bank
CREATE TABLE customer_communication (
  customer_communication_id NUMBER(10) PRIMARY KEY,
  customer_id NUMBER(10) NOT NULL,
  communication_type VARCHAR2(20) NOT NULL,
  communication_date DATE NOT NULL,
  description VARCHAR2(255),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Tabela historii konta
CREATE TABLE account_history (
    history_id NUMBER(8) PRIMARY KEY,
    account_number NUMBER(8) NOT NULL,
    action_type VARCHAR2(20) NOT NULL,
    action_date DATE NOT NULL,
    old_value VARCHAR2(255),
    new_value VARCHAR2(255),
    FOREIGN KEY (account_number) REFERENCES accounts(account_number)
);

COMMIT;