CREATE PROCEDURE DodajRole
    @Tytul NVARCHAR(50),
    @RokProdukcji INT,
    @Imie NVARCHAR(20),
    @Nazwisko NVARCHAR(30),
    @Rola NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @IdFilm INT, @IdAktor INT;

    -- Sprawdzenie, czy film istnieje
    SELECT @IdFilm = IdFilm
    FROM Film
    WHERE Tytul = @Tytul AND RokProdukcji = @RokProdukcji;

    IF @IdFilm IS NULL
    BEGIN
        RAISERROR('Film nie istnieje.', 16, 1);
        RETURN;
    END

    -- Sprawdzenie, czy aktor istnieje
    SELECT @IdAktor = IdAktor
    FROM Aktor
    WHERE Imie = @Imie AND Nazwisko = @Nazwisko;

    IF @IdAktor IS NULL
    BEGIN
        RAISERROR('Aktor nie istnieje.', 16, 1);
        RETURN;
    END

    -- Sprawdzenie, czy dana rola już istnieje
    IF EXISTS (
        SELECT 1 FROM Rola
        WHERE IdFilm = @IdFilm AND IdAktor = @IdAktor AND Rola = @Rola
    )
    BEGIN
        RAISERROR('Taka rola już istnieje. Zmień nazwę roli.', 16, 1);
        RETURN;
    END

    -- Dodanie roli
    INSERT INTO Rola (IdAktor, IdFilm, Rola)
    VALUES (@IdAktor, @IdFilm, @Rola);
END
