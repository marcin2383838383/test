CREATE TRIGGER trg_ZabronDuplikatuFilmu
ON Film
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Film f
        JOIN INSERTED i ON f.Tytul = i.Tytul AND f.RokProdukcji = i.RokProdukcji
    )
    BEGIN
        RAISERROR('Film o tym tytule i roku produkcji już istnieje.', 16, 1);
        RETURN;
    END

    -- Wstawienie, jeśli brak duplikatu
    INSERT INTO Film (IdFilm, Tytul, RokProdukcji, CzasTrwania, IdAktor)
    SELECT IdFilm, Tytul, RokProdukcji, CzasTrwania, IdAktor
    FROM INSERTED;
END
