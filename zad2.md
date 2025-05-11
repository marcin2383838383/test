CREATE PROCEDURE AddNewRole
    @MovieTitle NVARCHAR(255),
    @ProductionYear INT,
    @ActorFirstName NVARCHAR(255),
    @ActorLastName NVARCHAR(255),
    @RoleName NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MovieId INT, @ActorId INT;

    -- Sprawdzenie istnienia filmu
    SELECT @MovieId = ID FROM MOVIE
    WHERE TITLE = @MovieTitle AND YEAR = @ProductionYear;

    IF @MovieId IS NULL
    BEGIN
        RAISERROR('Film nie istnieje.', 16, 1);
        RETURN;
    END

    -- Sprawdzenie istnienia aktora
    SELECT @ActorId = ID FROM ACTOR
    WHERE FIRSTNAME = @ActorFirstName AND LASTNAME = @ActorLastName;

    IF @ActorId IS NULL
    BEGIN
        RAISERROR('Aktor nie istnieje.', 16, 1);
        RETURN;
    END

    -- Sprawdzenie, czy rola już istnieje
    IF EXISTS (
        SELECT 1 FROM CASTS
        WHERE MOVIE_ID = @MovieId AND ACTOR_ID = @ActorId AND ROLE = @RoleName
    )
    BEGIN
        RAISERROR('Rola już istnieje. Zmień nazwę roli.', 16, 1);
        RETURN;
    END

    -- Wstawienie nowej roli
    INSERT INTO CASTS (MOVIE_ID, ACTOR_ID, ROLE)
    VALUES (@MovieId, @ActorId, @RoleName);
END
