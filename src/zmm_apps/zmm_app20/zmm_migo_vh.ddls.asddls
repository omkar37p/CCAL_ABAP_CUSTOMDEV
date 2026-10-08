@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Goods Movements Value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel: { dataCategory: #VALUE_HELP }
@Search.searchable: true
define view entity ZMM_MIGO_VH
  as select from I_MaterialDocumentHeader_2
{
      @Search.defaultSearchElement: true
  key MaterialDocument as Materialdocument,
  key MaterialDocumentYear as Materialdocumentyear,
      DocumentDate as Migodate,
      @Search.defaultSearchElement: true
      ReferenceDocument as InvoiceNo,
      DocumentDate as Invoicedate,
      @Search.defaultSearchElement: true
      Plant

}
