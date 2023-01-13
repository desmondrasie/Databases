#DATABASES ASSIGNMENT - Queries

--Q1a

SELECT *
FROM MOVIE
WHERE grossearnings between 1200000 and 1500000;

--Q1b

SELECT Person.ID,firstName,lastName,OscarYear 
FROM ((Actor JOIN Act ON Actor.ID = Act.actorID) JOIN Person ON Person.ID = Actor.ID) 
WHERE OscarorNot = 'Yes' 
    AND Person.id in (
        SELECT Person.ID 
        FROM ((Actor JOIN Act ON Actor.ID = Act.actorID) JOIN Person ON Person.ID = Actor.ID) 
        WHERE OscarorNot = 'Yes' 
        GROUP BY Person.ID 
        HAVING COUNT(oscaryear) >= 2) 
        ORDER BY Person.ID ASC;


--Q2

SELECT cardID,points,goerID,firstname,lastname
FROM ((Card JOIN Has ON Card.ID = Has.cardID) JOIN Person ON Has.goerID = Person.ID)
GROUP BY cardID,points,goerID,firstname,lastname
HAVING MAX(points) = (
	SELECT MAX(points) FROM Card);


--Q3a

SELECT movie.ID,genre,title
FROM Movie 
WHERE grossearnings = (
	SELECT MAX(grossearnings) AS Grossearnings 
	FROM (((Movie JOIN Direct ON Movie.id = Direct.movieID) JOIN Director ON Director.id = Direct.directorID) JOIN Person ON Person.id = Director.id)
	Where firstname = 'Gennadi');

--Q3b

SELECT title
FROM Movie
WHERE grossearnings = (
	SELECT MAX(grossearnings) 
	FROM Movie);

--Q4a

SELECT COUNT(actorID) AS NumberofActors
FROM (
	SELECT actorID,COUNT(movieID) AS NumberofMovies
	FROM Act
	GROUP BY actorID) 
WHERE NumberofMovies > 5;

--Q4b

SELECT Person.ID,firstname,lastName 
FROM (Person JOIN Act ON Person.ID = Act.actorId) 
GROUP BY Person.ID,firstName,lastName
HAVING COUNT(movieID) in (
        SELECT MAX(NumberOfMovies) 
        FROM (
            SELECT Person.ID, COUNT(movieID) AS NumberofMovies 
            FROM (Person JOIN Act ON Person.ID = Act.actorId) 
            GROUP BY Person.ID));

--Q5

SELECT firstname,lastname,SUM(paidamount) AS Amount
FROM (((Person JOIN Goer ON Person.id = Goer.ID) JOIN Make ON Goer.ID = Make.goerID) JOIN Transaction ON Make.transactionID = Transaction.id)
WHERE date like '__/__/2015'
GROUP BY firstname,lastname
HAVING (SUM(paidamount) > 150)
ORDER BY SUM(paidamount) DESC;

--Q6a
SELECT studioAffiliation, COUNT(DISTINCT movieID) AS NumberOfMovies FROM Director JOIN Direct ON Director.id = Direct.directorID GROUP BY studioAffiliation;

SELECT studioAffiliation, COUNT(DISTINCT movieID) AS NumberOfMovies
FROM Director JOIN Direct ON Director.id = Direct.directorID
GROUP BY studioAffiliation;

--Q6b

SELECT studioAffiliation, COUNT(DISTINCT movieID) AS NumberOfMovies
FROM Director JOIN Direct ON Director.id = Direct.directorID
WHERE budget >= 7000000 and awardName IS NOT NULL
GROUP BY studioAffiliation;

--Q7

SELECT DISTINCT Movie.ID,title,genre,releaseDate 
FROM (((Visit JOIN Show ON Visit.movietheaterID = Show.movietheaterID) JOIN Movie ON Movie.id = Show.movieID) JOIN Act ON Act.movieID = Movie.ID) 
WHERE goerID in (
    SELECT id 
    FROM Actor);

--Q8a

SELECT DISTINCT movietheaterID,SUM(quantity) AS Quantity,type 
FROM (Belong JOIN Sold ON Belong.productID = Sold.productID) 
GROUP BY movietheaterID,type 
HAVING SUM(quantity) > 50 
ORDER BY Quantity ASC;

--Q8b

SELECT movietheaterID, SUM(price*quantity) AS Sales, type 
FROM ((Belong JOIN Sold ON Belong.productID = Sold.productID) JOIN Product ON Product.ID = Belong.productID) 
GROUP BY movietheaterID,type 
HAVING SUM(price*quantity) > 570 
ORDER BY Sales ASC;

--Q9a

SELECT DISTINCT id,name,province 
FROM Show a, Show b,MovieTheater 
WHERE a.day = b.day 
    AND a.movieID in (SELECT id FROM Movie Where genre = 'R') 
    AND b.movieID in (SELECT id FROM Movie Where genre = 'D') 

--Q9b

SELECT DISTINCT id,name,province 
FROM (
    SELECT EXTRACT (year FROM date) AS year,movietheaterID,SUM(price) 
    FROM Visit 
    WHERE movietheaterID in (
        SELECT id 
        FROM MovieTheater 
        WHERE Screens >= 4) 
    GROUP BY EXTRACT (year FROM date),movietheaterID 
    HAVING SUM(price) < 10000) mtRevenue JOIN MovieTheater ON MovieTheater.id = mtRevenue.movietheaterID

--Q10

SELECT category, SUM(price*quantity) AS TotalSales 
FROM Belong Join Product ON Belong.productID = Product.ID 
GROUP BY category 
ORDER BY TotalSales DESC 
FETCH FIRST ROW ONLY;













--------
-----------
------------

SELECT actorID FROM Act GROUP BY actorID 

SELECT COUNT(actorID) AS NumberofActors
FROM (
	SELECT actorID,COUNT(movieID) AS NumberofMovies
	FROM Act
	GROUP BY actorID
	HAVING MAX(NumberofMovies)) 


SELECT actorID,COUNT(movieID) AS NumberofMovies FROM Act GROUP BY actorID HAVING MAX()



