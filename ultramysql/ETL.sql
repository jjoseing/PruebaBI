use ultradb_pedido_datamart;
SELECT 
	p.id_producto,
    p.marca,
    p.nombre_producto,
    p.precio_compra, 
    p.precio_venta,
    c.nombre_categoria,
    f.nombre_familia
FROM ultradb.producto as p  
	inner join ultradb.categoria as c on p.id_categoria= c.id_categoria 
    inner join ultradb.familia as f on p.id_familia= f.id_familia;
   
   insert into  dm_tiempo(
	Fecha,
    DIA_SEMANA,
    COD_MES,
    DES_MES,
    COD_TRIMESTRE,
    DES_TRIMESTRE,
	COD_ANIO
)
   SELECT 
	date_format(ve.fecha_pagos, '%Y-%m-%d')  as Fecha
    ,DAYNAME(ve.fecha_pagos ) AS DIA_SEMANA
	,MONTH(ve.fecha_pagos ) AS COD_MES
	,MONTHNAME(ve.fecha_pagos ) AS DES_MES
	,QUARTER( ve.fecha_pagos ) AS COD_TRIMESTRE
	,CONCAT('Trimestre ', QUARTER(ve.fecha_pagos )) AS DES_TRIMESTRE
	,YEAR(ve.fecha_pagos) AS COD_ANIO
FROM ultradb.venta as ve WHERE ve.fecha_pagos IS NOT NULL
       GROUP BY date_format(ve.fecha_pagos, '%Y-%m-%d')
       ORDER BY date_format(ve.fecha_pagos, '%Y-%m-%d');
       
SELECT  c.nombre_cliente FROM ultradb.cliente as c;
SELECT  v.nombre_vendedor FROM ultradb.vendedor as v;

SELECT 
DT.DTiem_id,
DP.DProd_id,
DCLI.DCli_id,
DVEND.DVend_id,
sum(G.Ventas) as VENTAS,
sum(G.Cantidad) as CANT_UNID,
sum(G.Costos) as COSTOS,
sum(G.Descuentos) as DESCTOS,
sum(G.min_confirmacion) as CANT_MIN_CONFIRM,
sum(G.min_despacho) as CANT_MIN_DESPACH,
sum(G.horas_entrega2) as CANT_HORAS_ENTREGA,
COUNT(DISTINCT G.Nom_cli) AS Cant_clientes
FROM (
	SELECT  
		date_format(pe.Fecha_crea, '%Y-%m-%d') AS Fecha
		,TIMESTAMPDIFF(MINUTE,pe.Fecha_crea, pe.Fecha_confirm) AS min_confirmacion
		,TIMESTAMPDIFF(MINUTE,pe.Fecha_confirm, pe.Fecha_envio) AS min_despacho
		,ROUND( time_to_sec( TIMEDIFF(pe.Fecha_entrega, pe.Fecha_envio) ) /3600, 2) as horas_entrega2
		,p.Cod_prod
		 ,p.Nom_prod
		 ,c.Nom_cat
		 ,f.Nom_fam
		,ped.Cantidad
		,ped.Cantidad*ped.Prec_compra_un as Costos
		,ped.Cantidad*(ped.Prec_venta_un - ped.Total_desc_un ) as Ventas
		,ped.Cantidad*(ped.Total_desc_un ) as Descuentos
        ,cli.Nom_cli
        ,v.Nom_vend
	FROM farmadb.pedido as pe
		inner join farmadb.pedido_det as ped on pe.Ped_id= ped.Ped_id 
		inner join farmadb.producto as p on ped.Prod_id= p.Prod_id 
		inner join farmadb.categoria as c on p.Cat_id= c.Cat_id 
		inner join farmadb.familia as f on c.Fam_id= f.Fam_id 
        inner join farmadb.cliente as cli on pe.Cli_id= cli.Cli_id 
        inner join farmadb.vendedor as v on pe.Vend_id= v.Vend_id 
	)  AS G
    
    inner join dm_producto AS DP ON p.id_prod = DP.Cod_prod
    inner join dm_tiempo AS DT ON p.Fecha = DT.Fecha
    inner join dm_cliente AS DC ON p.Nom_cli = DCLI.Nom_cli
    inner join dm_vendedor AS DV ON p.Nom_vend = DVEND.Nom_vend
    /*inner join dm_vendedor AS DVEND ON G.Nom_vend = DVEND.Nom_vend
    inner join dm_vendedor AS DVEND ON G.Nom_vend = DVEND.Nom_vend*/
    
	GROUP BY DP.DProd_id, DT.DTiem_id, DCLI.DCli_id, DVEND.DVend_id
;

       
       