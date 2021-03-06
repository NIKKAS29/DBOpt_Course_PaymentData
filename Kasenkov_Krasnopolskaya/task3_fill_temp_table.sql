DECLARE @ID_1  uniqueidentifier = NEWID();
DECLARE @ID_2 uniqueidentifier = NEWID();
DECLARE @ID_3 uniqueidentifier = NEWID();
DECLARE @ID_4 uniqueidentifier = NEWID();

DECLARE @countPaymentParticipantTarget INT = 40;

DECLARE @PaymentCategoryOids TABLE(
	num bigint INDEX ix CLUSTERED,
	Oid uniqueidentifier);
INSERT INTO @PaymentCategoryOids(num,Oid) select ROW_NUMBER() over(ORDER BY Oid) as num, Oid from PaymentData.dbo.PaymentCategory;

DECLARE @ProjectOids TABLE(
	num bigint INDEX ix CLUSTERED,
	Oid uniqueidentifier);
INSERT INTO @ProjectOids(num,Oid) select ROW_NUMBER() over(ORDER BY Oid) as num, Oid from PaymentData.dbo.Project;

DECLARE @PaymentParticipantOids TABLE(
	num bigint INDEX ix CLUSTERED,
	Oid uniqueidentifier);
INSERT INTO @PaymentParticipantOids(num,Oid) select ROW_NUMBER() over(ORDER BY Oid) as num, Oid from PaymentData.dbo.PaymentParticipant;

INSERT TempPayment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) VALUES 
		(@ID_1,
		ForGenerData.dbo.genRandomInteger(@ID_1, -10000, 10000),
		(select Oid from @PaymentCategoryOids where num=2),
		(select Oid from @ProjectOids where num=1),
		ForGenerData.dbo.genRandomString(@ID_1),
		ForGenerData.dbo.genRandomString(@ID_2),
		ForGenerData.dbo.genDate(@ID_1), 
		(select Oid from @PaymentParticipantOids where num=ForGenerData.dbo.genRandomInteger(@ID_1,1,@countPaymentParticipantTarget)),
		(select Oid from @PaymentParticipantOids where num=ForGenerData.dbo.genRandomInteger(@ID_2,1,@countPaymentParticipantTarget)),
		ForGenerData.dbo.genRandomInteger(@ID_1, -1000, 1000),
		NULL, 
		ForGenerData.dbo.genDate(@ID_2),
		ForGenerData.dbo.genRandomString(@ID_3),
		ForGenerData.dbo.genBinValue(@ID_1),
		ForGenerData.dbo.genRandomString(@ID_4));