@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD Custom Report Part 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #TRANSACTIONAL
}
define root view entity ZSD_REPORT_2RV as select from ZSDINVOCIE_PRCD_TAX as BOI 
                                         left outer join I_DeliveryDocumentItem as DOI on DOI.DeliveryDocument = BOI.ReferenceSDDocument
                                                                        and DOI.DeliveryDocumentItem = BOI.ReferenceSDDocumentItem
                                                                        and DOI.ItemIsBillingRelevant = 'K'
                                         left outer join I_DeliveryDocument as DOH on DOH.DeliveryDocument = DOI.DeliveryDocument
                                         
                                         
                                         left outer join I_SalesOrderItem as SOI on SOI.SalesOrder = DOI.ReferenceSDDocument
                                                                        and SOI.SalesOrderItem = DOI.ReferenceSDDocumentItem
                                         left outer join I_SalesOrder as SOH on SOH.SalesOrder = SOI.SalesOrder

                                         left outer join I_SalesQuotationItem as Qua on Qua.SalesQuotation = SOI.ReferenceSDDocument and
                                                                                        Qua.SalesQuotationItem = SOI.ReferenceSDDocumentItem  
                                         left outer join I_SalesContractItem as con on con.SalesContract = SOI.ReferenceSDDocument and
                                                                                       con.SalesContractItem = SOI.ReferenceSDDocumentItem
                                         left outer join I_ProductPlantBasic as HSN on HSN.Product = BOI.Product and
                                                                                HSN.Plant = BOI.Plant
                                                                                       
                                         left outer join I_Customer as ship_cus on ship_cus.Customer = DOH.ShipToParty
                                         left outer join ZSDCAPP04 as cus_pak on cus_pak.delvnum = DOI.DeliveryDocument
                                         left outer join I_SalesOrderScheduleLine as DOH_PEN on DOH_PEN.SalesOrder = SOI.SalesOrder 
                                                                                                and DOH_PEN.SalesOrderItem = SOI.SalesOrderItem
                                                                                                and DOH_PEN.IsRequestedDelivSchedLine != 'X'
                                         
//***************Sales Return Order Invoice Details*********                                                                                         
                                         left outer join ZSD_RETURN_ORDER as Return on Return.ReferenceSDDocument = BOI.ReferenceSDDocument
                                                                                    and Return.ReferenceSDDocumentItem = BOI.ReferenceSDDocumentItem
                                         
                                                                                       

{
key BOI.BillingDocument,
key BOI.BillingDocumentItem,
key DOI.DeliveryDocument,
key DOI.DeliveryDocumentItem,
key SOI.SalesOrder,
key SOI.SalesOrderItem,
BOI.DocumentReferenceID as ODNNumber,
BOI.ReferenceSDDocument,
BOI.ReferenceSDDocumentItem,
BOI.CreationDate,
BOI.CreationTime,
Qua.SalesQuotation,
Qua.SalesQuotationItem,
Qua.ReferenceSDDocument as SalesInquiry,
con.SalesContract,
        case
            when ship_cus.Customer is not initial then ship_cus.Customer
            when Return.Customer is not initial then Return.Customer
            else null end as shipCustomer,
//        ship_cus.Customer as shipCustomer,
        case
            when ship_cus.BusinessPartnerName1 is not initial then ship_cus.BusinessPartnerName1
            when Return.BusinessPartnerName1 is not initial then Return.BusinessPartnerName1
            else null end as shipPartyName1,
//        ship_cus.BusinessPartnerName1 as shipPartyName1,
        case
            when ship_cus.BusinessPartnerName2 is not initial then ship_cus.BusinessPartnerName2
            when Return.BusinessPartnerName2 is not initial then Return.BusinessPartnerName2
            else null end as shipPartyName2,
//        ship_cus.BusinessPartnerName2 as shipPartyName2,
        case
            when ship_cus.StreetName is not initial then ship_cus.StreetName
            when Return.StreetName is not initial then Return.StreetName
            else null end as shipcusStreetName,
//        ship_cus.StreetName as shipcusStreetName,
        case
            when ship_cus.CityName is not initial then ship_cus.CityName
            when Return.CityName is not initial then Return.CityName
            else null end as shipcusCityName,
//        ship_cus.CityName as shipcusCityName,
        case
            when ship_cus.Region is not initial then ship_cus.Region
            when Return.Region is not initial then Return.Region
            else null end as shiptostate,
//        ship_cus.Region as shiptostate,
        cast(DOI.YY1_PCKLIST_DLI as abap.char( 15 )) as TokenNumber,
        DOH.YY1_ModeOfTransport_DLH as ModeofTransporter,
        BOI.BaseUnit,
        case
            when BOI.BillingDocumentType = 'G2' and Return.OrderQuantity is not initial then (-1 * Return.OrderQuantity)
            when Return.OrderQuantity is not initial then Return.OrderQuantity
            when SOI.OrderQuantity is not initial then cast(SOI.OrderQuantity as abap.dec( 9, 3 ))
            else null end as OrderQuantity,
        cast(cast(SOI.OrderQuantity as abap.dec( 9, 3 )) - cast(DOH_PEN.DeliveredQtyInOrderQtyUnit as abap.dec( 9, 3 )) as abap.dec( 9, 3 )) as PendingQuantity,            
        BOI.CustomerPaymentTerms,
        cus_pak.Lrnumber as LRNo,
        DOH.YY1_DriverDetails_DLH as DriverDetails,
        cast(DOH.YY1_VolumePerCylinder_DLH as abap.int4) as VolumePerCylinder,
        DOH.YY1_CylinderDetailSeal_DLH,
        DOH.YY1_FreightTerms_DLH as FreightTerms,
        cus_pak.Remarks as Remarks,
        BOI.IncotermsClassification as Incoterms,
        BOI.IncotermsLocation1 as IncLocation,
        BOI.AccountingDocument as JournalEntryNo,
        BOI.FiscalYear,
        DOH.YY1_Transporter_DLH as TransporterName,
//        cus_pak.Trspname as TransporterName,
        DOH.YY1_VehicleNumber_DLH as Vehiclenumber,
        cus_pak.Trucktyp as WheelerType, 
        cast(DOH.YY1_GrossWT_DLH as abap.dec( 9, 3 )) as GrossWt,
        cast(DOH.YY1_NETWT_DLH as abap.dec( 9, 3 )) as NetWt,
        cast(DOH.YY1_TAREWT_DLH as abap.dec( 9, 3 )) as TareWt,
        cast(DOH.YY1_CONCN_DLH as abap.dec( 9, 3 )) as Concentration,
        cast(DOH.YY1_CHARWT_DLH as abap.dec( 9, 3 )) as Charwt,
        DOH.YY1_NOOFCylinder_DLH as NoOfCylinder,
        DOH.YY1_Place_DLH as Place,
        BOI.SalesOrganization,
        BOI.Division,
        HSN.ConsumptionTaxCtrlCode as HSN,
        SOH.PurchaseOrderByCustomer as cussoref ,
        BOI.CompanyCode,
        BOI.Plant,       
        BOI.InvoiceTime


}
