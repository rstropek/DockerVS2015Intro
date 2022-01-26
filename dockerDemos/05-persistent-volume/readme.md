# Azure Files-based Volumes

This sample demonstrates the use of Azure Files-based volumes. It uses a postgres DB for the demo.

## Postgres with local data

1. Run postgres DB without volume
    ```
        docker run --name mydb -e POSTGRES_PASSWORD=P@ssw0rd! -e PGDATA=/dbdata -d -p 5432:5432 postgres
    ```

2. Run postgres client with link to DB
    ```
        docker run -it --link mydb --rm postgres psql -h mydb -p 5432 -U postgres
    ```

3. Create table and fill it with some data
    ```
        CREATE TABLE Customer (ID INT PRIMARY KEY, CustomerName VARCHAR(100));
        INSERT INTO Customer VALUES (1, 'Foo');
        INSERT INTO Customer VALUES (1, 'Bar');
        SELECT * FROM Customer;
        \q
    ```

4. Remove DB, note that your data is gone
    ```
        docker rm -f mydb
    ```

## Postgres with volume container

1. Create volume container
    ```
        docker volume create dbstore
    ```

1. Run postgres DB on Azure Files-based volume
    ```
        docker run --name mydb -e POSTGRES_PASSWORD=P@ssw0rd! -e PGDATA=/dbdata -v dbstore:/dbdata -d -p 5432:5432 postgres
    ```

2. Run postgres client with link to DB (same statement as shown above)

3. Create table and fill it with some data (same statements as shown above)

4. Remove DB  (same statement as shown above)

5. Recreate postgres DB as shown in step 2 (with volume mapping)

6. Run postgres client again as shown in step 3

7. Check that data is still there. Is survived on the Azure Files volume.
    ```
        SELECT * FROM Customer;
        \q
    ```
