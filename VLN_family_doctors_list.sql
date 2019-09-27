SET NOCOUNT ON;

SELECT DISTINCT (SELECT Param_reiksme FROM Sistemos_parametrai WHERE Param_kodas = 29) as Istaigos_kodas,
	GDT_ID as 'Gydytojo ID', CURRENT_TIMESTAMP as 'Įrašo_sukurimo_data'
  FROM Gydytojas where pas_kodas in ('1','2','3') and GDIS_DATA_IKI > CURRENT_TIMESTAMP