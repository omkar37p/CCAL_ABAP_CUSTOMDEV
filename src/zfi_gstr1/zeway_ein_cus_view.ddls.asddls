@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'E-Way and E-Invoice Custom Views'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZEWAY_EIN_CUS_VIEW as select from I_IN_ElectronicDocInvoice as E_IN
left outer join I_IN_ElectronicDocTransptRegn as E_Way on E_Way.ElectronicDocCompanyCode = E_IN.ElectronicDocCompanyCode
                                                and E_Way.ElectronicDocCountry = E_IN.ElectronicDocCountry
                                                and E_Way.ElectronicDocSourceKey = E_IN.ElectronicDocSourceKey
{
    key E_IN.ElectronicDocUUID as E_InoviceUUID,
    key E_Way.ElectronicDocUUID as E_WayUUID,
    E_IN.ElectronicDocCompanyCode,
    E_IN.ElectronicDocCountry,
    E_IN.ElectronicDocSourceType,
    E_IN.ElectronicDocSourceKey,
    E_IN.ElectronicDocType as ElectronicDocType_Ein,
    E_IN.IN_ElectronicDocAcknNmbr,
    E_IN.IN_ElectronicDocAcknDate,
    E_IN.IN_EDocEInvcBusinessPlace,
    E_Way.ElectronicDocType as ElectronicDocType_Eway,
    E_Way.IN_ElectronicDocEWbillNmbr,
    E_Way.IN_EDocEWbillCreateDate
    
}
