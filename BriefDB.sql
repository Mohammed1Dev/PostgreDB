--creation table Clients--
CREATE TABLE Clients (
    numPass      varchar(80),
    nom          varchar(20),          
    ville        varchar(20)
);
--creation table RESERVATIONS--
CREATE TABLE RESERVATIONS  (
    numR      int,
    numPass   varchar(80),          
    numC      int,
    arrivée   date,
    départ    date
);
--creation table CHAMBRES--
CREATE TABLE CHAMBRES  (        
    numC      int,
    lits      int,
    prix      float
);


INSERT INTO "Clients" VALUES ('NA0001250', 'Mohammed', 'Safi');
INSERT INTO "Clients" VALUES ('NA0034554', 'Youssef', 'Rabat');
INSERT INTO "Clients" VALUES ('NA0045645', 'Zakaria', 'Agadir');

INSERT INTO "RESERVATIONS" VALUES (0003243, 'NA0045645', 125, '30-5-2021');
INSERT INTO "RESERVATIONS" VALUES (0001254, 'NA0001250', 126, '14-2-2022');
INSERT INTO "RESERVATIONS" VALUES (0001545, 'NA0001250', 127, '27-3-2023');

INSERT INTO "CHAMBRES" VALUES (125, 12, 450.45);
INSERT INTO "CHAMBRES" VALUES (126, 15, 334.5);
INSERT INTO "CHAMBRES" VALUES (127, 27, 234.89);


	
SELECT * FROM "Clients"
SELECT * FROM "CHAMBRES"
SELECT * FROM "RESERVATIONS"

-- //First Function 
CREATE FUNCTION chambresRéservées ()
RETURNS TABLE(numC int ,lits int,prix real) AS "list"

BEGIN
    RETURN QUERY SELECT
     ch.*
    FROM
     "CHAMBRES" AS ch,"RESERVATIONS" AS r
     WHERE ch."numC"=r."numC" AND EXTRACT(MONTH FROM r."départ")=08
	 GROUP BY ch."numC";
END;
"list" LANGUAGE 'plpgsql';


-- Function 2

CREATE FUNCTION ListClient ()
RETURNS TABLE(numPass int ,nom varchar,ville varchar) as $list$

BEGIN
    RETURN QUERY SELECT
     cl.*
    FROM
     "CHAMBRES" AS ch,"RESERVATIONS" AS r,"Clients" AS cl
     WHERE ch."numC"=r."numC" AND r."numPass" = cl."numPass" AND ch."prix">700
	 GROUP BY cl."numPass";
END; 
$list$ LANGUAGE 'plpgsql';

-- 

-- Function 3

CREATE FUNCTION chambresRéservéesParClient ()
RETURNS TABLE(numC int ,lits int,prix real) as $list$

BEGIN
    RETURN QUERY SELECT
     ch.*
    FROM
     "CHAMBRES" AS ch,"RESERVATIONS" AS r,"Clients" AS cl
     WHERE ch."numC"=r."numC" AND r."numPass" = cl."numPass" AND cl.nom Like'A%'
	 GROUP BY ch."numC";
END; 
$list$ LANGUAGE 'plpgsql';

-- 
-- 
-- FUNCTION 4
CREATE FUNCTION clientsRéservées ()
RETURNS TABLE(numPass int ,nom varchar,ville varchar) as $list$

BEGIN
    RETURN QUERY SELECT 
     cl.*
    FROM
     "CHAMBRES" AS ch, "RESERVATIONS" AS r,"Clients" AS cl
     WHERE ch."numC"= r."numC" AND r."numPass" = cl."numPass" 
	 GROUP BY cl."numPass"
	having count(ch."numC")>2;
END; 
$list$ LANGUAGE 'plpgsql';

-- 
-- 
-- 
-- FUNCTION 5
CREATE FUNCTION clientsHabitent ()
RETURNS TABLE(numPass int ,nom varchar,ville varchar) as $list$

BEGIN
    RETURN QUERY SELECT 
     cl.*
    FROM
     "CHAMBRES" AS ch, "RESERVATIONS" AS r,"Clients" AS cl
     WHERE ch."numC"= r."numC" AND r."numPass" = cl."numPass" AND cl."ville"='Casablanca' 
	 GROUP BY cl."numPass"
	having count(ch."numC")>2 AND count(r."numPass")>2 ;
END; 
$list$ LANGUAGE 'plpgsql';

-- 
-- 
-- PROCEDURE 6
create procedure ModifierPrix()
language plpgsql    
as $update$
begin
    -- subtracting the amount from the sender's account 
    update "CHAMBRES" 
    set prix = 1000 
    where prix >= 700;
end;$update$


-- PROCEDURE 7
create procedure supprimerClient()
language plpgsql    
as $delete$
begin
    -- subtracting the amount from the sender's account 
    delete from "Clients" WHERE "Clients"."numPass" Not in(select "numPass" FROM "RESERVATIONS" );
end;$delete$

-- 
-- 
-- Procedure 8

create procedure ModifierPrixPourLits()
language plpgsql    
as $updatePrice$
begin
    -- subtracting the amount from the sender's account 
    update "CHAMBRES" 
    set prix = prix - 100
    where lits > 2;
end;$updatePrice$


CALL ModifierPrixPourLits()
CALL supprimerClient()
CALL ModifierPrix()
