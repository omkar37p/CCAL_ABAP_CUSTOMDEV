@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Note Header PV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZMM_APP20_HEAD_PV 
provider contract transactional_query
as projection on ZMM_APP20_HEAD_RV
{
    key Uuid,
//     @Consumption.semanticObject: 'MaterialMovement'   
@Consumption.semanticObject: 'MaterialDocument' 
    key Materialdocument,
    Materialdocumentyear,

    Invoicedate,
    Migodate,
    @ObjectModel.text.element: [ 'PlantName' ]
    Plant,
    Invoiceno,
    Purchaseorder,
    Purchaseorderitem,
    Supplier,
    Companycode,
    Goodsmovementtype,
    Purchaseorderdate,
    Supplierfullname,
    Street1,
    Street2,
    Cityname,
    Postalcode,
    Country,
    Region,
    Mdnno,
    Mdn,
    Mdndate,
    Remark,
    Filenameul,
        @Semantics.largeObject:{
          mimeType: 'MimetypeUl',
          fileName: 'FilenameUl',
          contentDispositionPreference: #INLINE
          }    
    Attachmentsul,
    Mimetypeul,
    PersonFullName,
    PlantName,
    @ObjectModel.text.element: [ 'PersonFullName' ]
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    /* Associations */
    _Item : redirected to composition child ZMM_APP20_ITEM_PV
}
