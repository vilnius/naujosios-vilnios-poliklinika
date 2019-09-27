SET NOCOUNT ON;

SELECT DISTINCT (SELECT Param_reiksme FROM Sistemos_parametrai WHERE Param_kodas = 29) as Istaigos_kodas,
	GDT_ID as 'Gydytojo ID', DG_LAIKAS_NUO as 'Laisvos registracijos data', CURRENT_TIMESTAMP as 'Įrašo_sukurimo_data'
  FROM DARBO_GRAFIKAS WITH (NOLOCK)
  inner join (SELECT DV_ID, GDT_ID FROM Gydytojas WHERE pas_kodas in ('1','2','3') and GDIS_DATA_IKI > CURRENT_TIMESTAMP) g on g.DV_ID = DG_DV_ID
  left join apsilankymai WITH (NOLOCK) on AP_DG_ID = DG_ID and AP_ANULIUOTAS = 'N'
  where AP_ASM_ID is null and DG_LAIKAS_NUO > CURRENT_TIMESTAMP and DG_ANULIUOTAS = 'false'