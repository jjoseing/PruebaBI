use farma_dmart_ped;
SELECT * FROM farmadb.producto as p;
SELECT 
	p.Cod_prod, CONCAT(p.Nom_prod, ' ', p.Concent, ' ', p.Presentac, ' frac', p.Fracciones ) as Nom_prod, 
    p.Prec_compra, p.Prec_venta,
	c.Nom_cat,
	f.Nom_fam
FROM farmadb.producto as p  
	inner join farmadb.categoria as c on p.Cat_id= c.Cat_id 
    inner join farmadb.familia as f on c.Fam_id= f.Fam_id;
