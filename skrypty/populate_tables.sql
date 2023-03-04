DECLARE
    v_id NUMBER;
BEGIN
    -- Utworzenie klientów
    add_customer('John', 'Doe', 555123456, 'johndoe@email.com', 'password1', 'Main Street', 'New York', 'USA', 12345);
    add_customer('Jane', 'Doe', 555654321, 'janedoe@email.com', 'password2', 'Second Street', 'Los Angeles', 'USA', 56789);
    add_customer('Michael', 'Smith', 555999888, 'michael.smith@email.com', 'password3', 'Third Street', 'Chicago', 'USA', 98765);
    add_customer('Emily', 'Johnson', 555111111, 'emilyj@email.com', 'password4', 'Fourth Street', 'Houston', 'USA', 22222);
    add_customer('Jacob', 'Williams', 555222222, 'jacobw@email.com', 'password5', 'Fifth Street', 'Phoenix', 'USA', 33333);
    add_customer('Nicholas', 'Jones', 555333333, 'nicholasj@email.com', 'password6', 'Sixth Street', 'Philadelphia', 'USA', 44444);
    add_customer('Sophia', 'Brown', 555444444, 'sophiab@email.com', 'password7', 'Seventh Street', 'San Antonio', 'USA', 55555);
    add_customer('Mia', 'Miller', 555555555, 'miam@email.com', 'password8', 'Main Street', 'New York', 'USA', 12345);
    add_customer('Emily', 'Brown', 555222111, 'emilyb@email.com', 'password9', 'Fourth Street', 'Houston', 'USA', 22222);
    add_customer('Jacob', 'Smith', 555222111, 'jacobs@email.com', 'password0', 'Fifth Street', 'Phoenix', 'USA', 33333);
    COMMIT;

    -- Utworzenie kont
    v_id := add_account(1, '2022-01-01', 1000.00, 'monthly', 5000.00);
    v_id := add_account(2, '2022-02-01', 2000.00, 'daily', 1000.00);
    v_id := add_account(3, '2022-03-01', 3000.00, 'monthly', 10000.00);
    v_id := add_account(4, '2022-04-01', 4000.00, 'daily', 500.00);
    v_id := add_account(5, '2022-05-01', 5000.00, 'monthly', 8000.00);
    v_id := add_account(6, '2022-06-01', 6000.00, 'daily', 800.00);
    v_id := add_account(7, '2022-07-01', 7000.00, 'monthly', 9000.00);
    v_id := add_account(8, '2022-08-01', 8000.00, 'daily', 600.00);
    v_id := add_account(9, '2022-09-01', 9000.00, 'monthly', 7000.00);
    v_id := add_account(10, '2022-10-01', 10000.00, 'daily', 400.00);
    COMMIT;

    -- Dodanie kart
    v_id := add_card(100000, '2022-01-01');
    v_id := add_card(100001, '2022-02-01');
    v_id := add_card(100002, '2022-03-01');
    v_id := add_card(100001, '2022-04-01');
    v_id := add_card(100003, '2022-05-01');
    v_id := add_card(100005, '2022-06-01');
    v_id := add_card(100007, '2022-07-01');
    v_id := add_card(100006, '2022-08-01');
    v_id := add_card(100005, '2022-09-01');
    v_id := add_card(100002, '2022-10-01');
    COMMIT;

    -- Dodanie traskacji
    add_transaction(100000, '2022-11-01', 'withdraw', 100);
    add_transaction(100001, '2022-11-02', 'deposit', 50);
    add_transaction(100002, '2022-11-03', 'withdraw', 75);
    add_transaction(100003, '2022-11-04', 'deposit', 200);
    add_transaction(100004, '2022-12-05', 'withdraw', 50);
    add_transaction(100005, '2022-12-06', 'deposit', 300);
    add_transaction(100006, '2022-12-07', 'withdraw', 25);
    add_transaction(100007, '2023-01-08', 'deposit', 400);
    add_transaction(100008, '2023-01-09', 'withdraw', 100);
    add_transaction(100009, '2023-01-10', 'deposit', 150);
    COMMIT;

    -- Dodanie kontaktów
    add_customer_communication(1, 'Email', '2021-01-01', 'Inquiry about account balance');
    add_customer_communication(2, 'Phone', '2021-02-15', 'Request for loan application');
    add_customer_communication(3, 'In-person', '2021-03-01', 'Discussion about investment options');
    add_customer_communication(4, 'Email', '2021-04-10', 'Complaint about service');
    add_customer_communication(5, 'Phone', '2021-05-20', 'Question about fees');
    add_customer_communication(6, 'In-person', '2021-06-01', 'Opening a new account');
    add_customer_communication(7, 'Email', '2021-07-05', 'Closing an account');
    add_customer_communication(8, 'Phone', '2021-08-15', 'Request for account statement');
    add_customer_communication(9, 'In-person', '2021-09-01', 'Opening a new account');
    add_customer_communication(10, 'Email', '2021-10-01', 'Inquiry about account balance');
    COMMIT;
end;