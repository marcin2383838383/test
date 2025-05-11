CREATE TRIGGER trg_PreventDuplicateMovie
ON MOVIE
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT TITLE, YEAR
        FROM MOVIE
        WHERE (TITLE, YEAR) IN (
            SELECT TITLE, YEAR FROM INSERTED
        )
    )
    BEGIN
        RAISERROR('Nie można dodać filmu o tym samym tytule i roku produkcji więcej niż raz.', 16, 1);
        RETURN;
    END

    -- Dozwolony insert
    INSERT INTO MOVIE (ID, TITLE, YEAR)
    SELECT ID, TITLE, YEAR FROM INSERTED;
END
