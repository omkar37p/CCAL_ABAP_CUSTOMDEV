@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD Return Order Invoice Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZSD_RETURN_ORDER as select from I_CustomerReturnDeliveryItem as Rtn_Doi
                                    inner join I_CustomerReturnDelivery as Rtn_Doh on Rtn_Doh.CustomerReturnDelivery = Rtn_Doi.CustomerReturnDelivery
                                    left outer join I_Customer as Rship_cus on Rship_cus.Customer = Rtn_Doh.ShipToParty
                                    left outer join I_CustomerReturnItem as Rcus_sales on Rcus_sales.CustomerReturn = Rtn_Doi.ReferenceSDDocument
                                                                and Rcus_sales.CustomerReturnItem = Rtn_Doi.ReferenceSDDocumentItem
{
    key Rtn_Doi.CustomerReturnDelivery,
    key Rtn_Doi.CustomerReturnDeliveryItem,    
        Rtn_Doi.DeliveryDocumentItemCategory,
        cast(Rtn_Doi.ActualDeliveryQuantity as abap.dec( 9, 3 )) as ActualDeliveryQuantity,
        Rtn_Doi.Plant,
        Rtn_Doi.ReferenceSDDocument,
        Rtn_Doi.ReferenceSDDocumentItem,
        Rtn_Doi.ReferenceSDDocumentCategory,
        Rtn_Doh.DeliveryDocumentType,
        Rtn_Doh.ShipToParty,
        Rship_cus.Customer,
        Rship_cus.BusinessPartnerName1 ,
        Rship_cus.BusinessPartnerName2 ,
        Rship_cus.StreetName ,
        Rship_cus.CityName ,
        Rship_cus.Region,
        cast(Rcus_sales.OrderQuantity as abap.dec( 9, 3 )) as OrderQuantity,
        cast(Rcus_sales.NetAmount * -1 as abap.dec( 14, 2 )) as NetAmount,
        Rcus_sales.CustomerReturnItemCategory
        
        
}
