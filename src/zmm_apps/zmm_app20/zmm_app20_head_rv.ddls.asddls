@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Note Header RV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP20_HEAD_RV
  as select from zmm_reject_hdb
  composition [0..*] of ZMM_APP20_ITEM_RV   as _Item
  association [1..1] to I_BusinessUserBasic as _uname       on $projection.Createdby = _uname.UserID
  association        to I_PlantStdVH               as Pname on $projection.Plant = Pname.Plant
{
  key uuid                  as Uuid,
  key materialdocument      as Materialdocument,
      materialdocumentyear  as Materialdocumentyear,

      invoicedate           as Invoicedate,
      migodate              as Migodate,
      plant                 as Plant,
      invoiceno             as Invoiceno,
      purchaseorder         as Purchaseorder,
      purchaseorderitem     as Purchaseorderitem,
      supplier              as Supplier,
      companycode           as Companycode,
      goodsmovementtype     as Goodsmovementtype,
      purchaseorderdate     as Purchaseorderdate,
      supplierfullname      as Supplierfullname,
      street1               as Street1,
      street2               as Street2,
      cityname              as Cityname,
      postalcode            as Postalcode,
      country               as Country,
      region                as Region,
      mdnno                 as Mdnno,
      mdn                   as Mdn,
      mdndate               as Mdndate,
      remark                as Remark,
      filenameul            as Filenameul,
      attachmentsul         as Attachmentsul,
      mimetypeul            as Mimetypeul,
      _uname.PersonFullName as PersonFullName,
      Pname.PlantName       as PlantName,
      @Semantics.user.createdBy: true
      createdby             as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat             as Createdat,
      @Semantics.user.lastChangedBy: true
      lastchangedby         as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat         as Lastchangedat,

      _Item
}
