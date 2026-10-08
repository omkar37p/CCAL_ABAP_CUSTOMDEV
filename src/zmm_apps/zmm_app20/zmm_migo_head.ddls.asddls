@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Goods Movements Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel: { dataCategory: #VALUE_HELP }
define view entity ZMM_MIGO_HEAD
  as select from I_MaterialDocumentHeader_2 as MOH
  left outer join I_MaterialDocumentItem_2 as MOI on MOI.MaterialDocumentYear = MOH.MaterialDocumentYear
                                              and MOI.MaterialDocument = MOH.MaterialDocument
                                              and MOI.MaterialDocumentItem = '0001'
  left outer join I_PurchaseOrderAPI01 as POH on POH.PurchaseOrder = MOI.PurchaseOrder
  left outer join ZMM_SUP_ADD as SUP on SUP.Supplier = MOI.Supplier
{
    key MOH.MaterialDocumentYear,
    key MOH.MaterialDocument,
    MOH.PostingDate as Invoicedate,
    MOH.DocumentDate as Migodate,
    MOH.Plant,
    MOH.ReferenceDocument as InvoiceNo,
    MOI.PurchaseOrder,
    MOI.PurchaseOrderItem,
    MOI.Supplier,
    MOI.CompanyCode,
    MOI.GoodsMovementType,
    POH.PurchaseOrderDate,
    SUP.BPSupplierFullName as SupplierFullName,
    SUP.StreetPrefixName1 as street1,
    SUP.StreetPrefixName2 as street2,
    SUP.CityName,
    SUP.PostalCode,
    SUP.Country,
    SUP.Region,
    SUP.GSTIN as SUPGSTIN,
    SUP.EmailAddress,    
        case
            when MOH.Plant = '1100' then 'GNANANANDA PLACE'
            when MOH.Plant = '1200' then 'NO 1 CHUNAMPET ROAD VILLPAKKAM VILLAGE'
            when MOH.Plant = '1300' then 'SAYALKUDI NO. 1,MOOKAIYUR SALAI'
            when MOH.Plant = '2100' then 'NO 1,Industrial Growth Centre'
            when MOH.Plant = '3100' then 'NO 650 CHIGURUPALEM ROAD'                                                
            else null end as Streetone,
         case
            when MOH.Plant = '1100' then 'KALAPET, PUDUCHERRY-605014'
            when MOH.Plant = '1200' then 'CHEYYUR TALUK,CHENGALPATTU,TAMIL NADU-603401'
            when MOH.Plant = '1300' then 'SAYALKUDI, RAMANATHAPURAM-623120'
            when MOH.Plant = '2100' then 'Polagam Karaikal Puducherry-609606'
            when MOH.Plant = '3100' then 'SRICITY-517646'                                                
            else null end as Streettwo,            
        case
            when MOH.Plant = '1100' then 'chemfabmktg@ccal.in'
            when MOH.Plant = '1200' then 'ccalsd1@ccal.in'
            when MOH.Plant = '1300' then 'ccalsd2@ccal.in'
            when MOH.Plant = '2100' then 'chemfabkaraikal@ckkl.in'
            when MOH.Plant = '3100' then 'ccalpvcomktg@ccal.in'                                                
            else null end as Email,            
         case
            when MOH.Plant = '1100' then 'L24290TN2009PLC071563'
            when MOH.Plant = '1200' then 'L24290TN2009PLC071563'
            when MOH.Plant = '1300' then 'L24290TN2009PLC071563'
            when MOH.Plant = '2100' then 'U24100TN2019PLC133285'
            when MOH.Plant = '3100' then 'L24290TN2009PLC071563'                                                
            else null end as CIN,
         case
            when MOH.Plant = '1100' then '34AADCT1820F1ZT'
            when MOH.Plant = '1200' then '33AADCT1820F3ZT'
            when MOH.Plant = '1300' then '33AADCT1820F3ZT'
            when MOH.Plant = '2100' then '34AAICC5330L1ZN'
            when MOH.Plant = '3100' then '37AADCT1820F1ZN'                                                
            else null end as GSTIN,
         case
            when MOH.Plant = '1100' then 'CHEMFAB ALKALIS LIMITED'
            when MOH.Plant = '1200' then 'CHEMFAB ALKALIS LIMITED'
            when MOH.Plant = '1300' then 'CHEMFAB ALKALIS LIMITED'
            when MOH.Plant = '2100' then 'CHEMFAB ALKALIS KARAIKAL LIMITED'
            when MOH.Plant = '3100' then 'CHEMFAB ALKALIS LIMITED'                                                
            else null end as PlantName            
    
  }
