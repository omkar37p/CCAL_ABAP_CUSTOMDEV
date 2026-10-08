@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO-DSC Authorized Sign User Matrix'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP19_RV
  as select from zmm_app19_tb1
{
  key userid        as Userid,
  key ccode         as Ccode,
  key cplant        as Cplant,
      usrname       as Usrname,
      ccname        as Ccname,
      plantname     as Plantname,
      signername    as Signername,
      formtmp       as Formtmp,
      formname      as Formname,
      prntque       as Prntque,
      @Semantics.user.createdBy: true
      createdby     as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat     as Createdat,
      @Semantics.user.lastChangedBy: true
      lastchangedby as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat as Lastchangedat

}
