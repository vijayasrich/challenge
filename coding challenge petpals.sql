--Tasks:
--1. Provide a SQL script that initializes the database for the Pet Adoption Platform ”PetPals”.
--2. Create tables for pets, shelters, donations, adoption events, and participants.
--3. Define appropriate primary keys, foreign keys, and constraints.
--4. Ensure the script handles potential errors, such as if the database or tables already exist.
create database PetPals 
create table Pets(
PetID int identity(1,1) primary key,
[Name] varchar(25) not null,
Age int not null,
Breed varchar(25) not null,
[Type] varchar(25) not null,
AvailableForAdoption BIT)create table Shelters(ShelterID int identity(1,1) primary key,[Name] varchar(40) not null,[Location] varchar(50) not null)create table Donations(DonationID int identity(1,1) primary key,DonorName varchar(30) not null,DonationType varchar(30) not null,DonationAmount decimal(10,2) not null,DonationItem varchar(40) not null,DonationDate date not null)alter table Donationsalter column DonationItem varchar(40)create table AdoptionEvents(EventID int identity(1,1) primary key,EventName varchar(50) not null,EventDate date not null,[Location] varchar(30))create table Participants(ParticipantID int identity(1,1) primary key,ParticipantName varchar(30) not null,ParticipantType varchar(30) not null,EventID int,foreign key(EventID) references AdoptionEvents(EventID))-- Insert values into pets table
insert into Pets ([Name], Age, Breed, [Type], AvailableForAdoption) values
('Bella', 3, 'Labrador', 'Dog', 1),
('Max', 5, 'Persian', 'Cat', 0),
('Charlie', 2, 'Beagle', 'Dog', 1),
('Milo', 4, 'Sphynx', 'Cat', 0),
('Coco', 1, 'Golden Retriever', 'Dog', 1)
select * from Pets
-- Insert values into shelters table
insert into Shelters ([Name],[Location]) values
('Happy Tails Shelter', '123 TN'),
('Paws and Claws Shelter', '456 AP'),
('Furry Friends Shelter', '789 TS'),
('Animal Haven Shelter', '123 AP '),
('Rescue Pals Shelter', '456 TN')
select * from Shelters
-- Insert values into donations table
insert into Donations (DonorName, DonationType, DonationAmount, DonationItem, DonationDate) values
('aa', 'Cash', 100, null, '2024-09-01'),
('bb', 'Item', 200, 'Dog Food', '2024-09-02'),
('cc', 'Cash', 50, null, '2024-09-03'),
('dd', 'Item', 300, 'Cat Toys', '2024-09-04'),
('ee', 'Cash', 75, null, '2024-09-05')
select * from Donations

-- Insert values into adoptionevents table
insert into AdoptionEvents (EventName,EventDate,[Location]) values
('Adopt-a-Pet Day', '2024-09-06', 'Tech Park'),
('Paws for a Cause', '2024-09-07', 'BMS Block'),
('Furry Friends Adoption Fair', '2024-09-08', 'Animal Shelter'),
('Adopt a Fur Baby', '2024-09-09', 'Pet Store Parking Lot'),
('Shelter Adoption Drive', '2024-09-10', 'Open Auditorium')
select * from AdoptionEvents

-- Insert values into participants table
insert into Participants(ParticipantName,ParticipantType,EventID) values
('Happy Tails Shelter', 'Shelter', 1),
('Paws and Claws Shelter', 'Shelter', 2),
('vc', 'Adopter', 1),
('cv', 'Adopter', 3),
('Furry Friends Shelter', 'Shelter', 4)
select * from Participants
--5. Write an SQL query that retrieves a list of available pets (those marked as available for adoption)from the "Pets" table. Include the pet's name, age, breed, and type in the result set. Ensure thatthe query filters out pets that are not available for adoption.
select [Name],Age,Breed,[Type]
from Pets
where AvailableForAdoption =1
--6. Write an SQL query that retrieves the names of participants (shelters and adopters) registeredfor a specific adoption event. Use a parameter to specify the event ID. Ensure that the queryjoins the necessary tables to retrieve the participant names and types.
declare @EventID int ='3'
select P.ParticipantName,P.ParticipantType
from Participants P
join AdoptionEvents AE on P.EventID = AE.EventID
WHERE AE.EventID = @eventid
--7. Create a stored procedure in SQL that allows a shelter to update its information (name andlocation) in the "Shelters" table. Use parameters to pass the shelter ID and the new information.Ensure that the procedure performs the update and handles potential errors, such as an invalidshelter ID.

--8. Write an SQL query that calculates and retrieves the total donation amount for each shelter (byshelter name) from the "Donations" table. The result should include the shelter name and thetotal donation amount. Ensure that the query handles cases where a shelter has received nodonations.
alter table donations
add shelter_id int
select s.name as shelter_name, isnull(sum(d.donationamount), 0) as total_donation_amount
from shelters s
left join donations d on s.shelterid = d.shelter_id
group by s.name
order by s.name
--9. Write an SQL query that retrieves the names of pets from the "Pets" table that do not have anowner (i.e., where "OwnerID" is null). Include the pet's name, age, breed, and type in the resultset.
--alter table Pets
--add OwnerID int
--update Pets
--set OwnerID=case
--when PetID in(1,2,4) then 1
--end
select * from Pets
select * from Participants
--select [Name],Age,Breed,[Type]
--from Pets
--where OwnerID IS NULL
select p.[name],p.age,p.breed,p.[type]
from pets p
left join participants par on p.petid = par.participantid
where par.participantid is null
--10. Write an SQL query that retrieves the total donation amount for each month and year (e.g.,January 2023) from the "Donations" table. The result should include the month-year and thecorresponding total donation amount. Ensure that the query handles cases where no donationswere made in a specific month-year.
select format(donationdate, 'MMMM yyyy') as month_year, sum(donationamount) as total_donation_amount
from donations
group by format(donationdate, 'MMMM yyyy')
order by min(donationdate)
--11. Retrieve a list of distinct breeds for all pets that are either aged between 1 and 3 years or olderthan 5 years.
select distinct Breed
from Pets
where Age between 1 and 3 or age > 5

--12. Retrieve a list of pets and their respective shelters where the pets are currently available foradoption.
drop table if exists Pets
create table Pets(
PetID int identity(1,1) primary key,
[Name] varchar(25) not null,
Age int not null,
Breed varchar(25) not null,
[Type] varchar(25) not null,
AvailableForAdoption BIT,
ShelterID int,
foreign key(ShelterID) references Shelters(ShelterID))
insert into Pets ([Name], Age, Breed, [Type], AvailableForAdoption,ShelterID) values
('Bella', 3, 'Labrador', 'Dog', 1,1),
('Max', 5, 'Persian', 'Cat', 0,2),
('Charlie', 2, 'Beagle', 'Dog', 1,3),
('Milo', 4, 'Sphynx', 'Cat', 0,4),
('Coco', 1, 'Golden Retriever', 'Dog', 1,5)


select  p.name as pet_name, p.type, s.name as shelter_name
from  pets p
join  shelters s on p.shelterid = s.shelterid
where  p.availableforadoption = 1

--13. Find the total number of participants in events organized by shelters located in specific city.Example: City=Chennai
update AdoptionEvents
set Location = cast([Location] as varchar(255))+ cast(' Chennai' as varchar(255))
select count(p.eventID) as TotalParticipants,e.EventName,e.eventid
from Participants p join AdoptionEvents e on p.EventID=e.EventID
where p.EventID=(select eventid from AdoptionEvents where [Location]='BMS Block Chennai')
group by e.EventName,e.EventID
--14. Retrieve a list of unique breeds for pets with ages between 1 and 5 years.
select distinct breed
from pets
where age between 1 and 5
--15. Find the pets that have not been adopted by selecting their information from the 'Pet' table.
alter table adoptionevents add petid int
alter table adoptionevents
add constraint fk_pet
foreign key (petid) references pets(petid)
select * from adoptionevents
select pets.*
from pets
left join adoptionevents on pets.petid = adoptionevents.petid
where adoptionevents.petid is null
--16. Retrieve the names of all adopted pets along with the adopter's name from the 'Adoption' and'User' tables.
select pets.name as pet_name, participants.participantname as adopter_name
from pets
join adoptionevents on pets.petid = adoptionevents.petid
join participants on adoptionevents.eventid = participants.eventid
--17. Retrieve a list of all shelters along with the count of pets currently available for adoption in eachshelter.
select shelters.name as shelter_name, count(pets.petid) as available_pets
from shelters
left join pets on shelters.shelterid = pets.shelterid and pets.availableforadoption = 1
group by shelters.name
--18. Find pairs of pets from the same shelter that have the same breed.
insert into pets (name, age, breed, type, availableforadoption, shelterid) values
('buddy', 3, 'labrador', 'dog', 1, 1),
('max', 2, 'labrador', 'dog', 1, 1) 
update pets
set [name]='cream' where petid=7
select p1.name as pet1_name, p2.name as pet2_name, shelters.name as shelter_name, p1.breed
from pets p1
join pets p2 on p1.breed = p2.breed and p1.petid <> p2.petid
join shelters on p1.shelterid = shelters.shelterid
order by shelters.name, p1.breed
--19. List all possible combinations of shelters and adoption events.
select shelters.name as shelter_name, adoptionevents.eventname as event_name
from shelters
cross join adoptionevents
--20. Determine the shelter that has the highest number of adopted pets.
select top 1 shelters.name as shelter_name, count(adoptionevents.petid) as adopted_pet_count
from shelters
join pets on shelters.shelterid = pets.shelterid
join adoptionevents on pets.petid = adoptionevents.petid
group by shelters.name
order by adopted_pet_count desc