SET NOCOUNT ON;

DECLARE @MinDate DATE = current_timestamp,
        @MaxDate DATE = dateadd(month,1,current_timestamp)


;WITH N1 (N) AS (SELECT 1 FROM (VALUES (1), (1), (1), (1), (1), (1), (1), (1), (1), (1)) n (N)),
N2 (N) AS (SELECT 1 FROM N1 AS N1 CROSS JOIN N1 AS N2),
N3 (N) AS (SELECT 1 FROM N2 AS N1 CROSS JOIN N2 AS N2),
N4 (N) AS (SELECT ROW_NUMBER() OVER(ORDER BY N1.N) FROM N3 AS N1 CROSS JOIN N3 AS N2)
SELECT (SELECT Param_reiksme FROM Sistemos_parametrai WHERE Param_kodas = 29) as Istaigos_kodas, GDT_ID as 'Gydytojo ID', DATEADD(DAY, N - 1, @MinDate) as 'Data nuo', DATEADD(DAY, N - 1, @MinDate) as 'Data iki', CURRENT_TIMESTAMP as 'Áraðo_sukurimo_data'
FROM    N4
inner join (SELECT DV_ID, GDT_ID FROM Gydytojas WHERE pas_kodas = '1' and GDIS_DATA_IKI > CURRENT_TIMESTAMP) g on 1=1
left join (SELECT DISTINCT DG_DV_ID,cast(DG_DATA as date) as grafikoData 
			FROM DARBO_GRAFIKAS 
			inner join Gydytojas on pas_kodas in ('1','2','3') and GDIS_DATA_IKI > CURRENT_TIMESTAMP and DG_DV_ID = DV_ID
			where DG_ANULIUOTAS = 'false' and DG_LAIKAS_NUO between @MinDate and @MaxDate
		) b on b.DG_DV_ID = g.DV_ID and b.grafikoData = DATEADD(DAY, N - 1, @MinDate)
WHERE 
	grafikoData is null and
  N < DATEDIFF(DAY, @MinDate, @MaxDate) + 2 AND
  DATEDIFF(DAY, 1 - N, @MinDate) % 7 NOT IN (5,6)
