@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DSC - Authorised Signer Details'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_APP10_RPV
  provider contract transactional_query
  as projection on ZSD_APP10_RV
{
      @ObjectModel.text.element: [ 'Usrname' ]
      @EndUserText.label: 'User ID'
  key Userid,
      @ObjectModel.text.element: [ 'Ccname' ]
  key Ccode,
      @ObjectModel.text.element: [ 'Dstchname' ]
  key Distchnl,
      @ObjectModel.text.element: [ 'Divsname' ]
  key Division,
      Usrname,
      Ccname,
      Dstchname,
      Divsname,
      Signername,
      Formtmp,
      Formname,
      Prntque,
      @Semantics.user.createdBy: true
      Createdby,
      @Semantics.systemDateTime.createdAt: true
      Createdat,
      @Semantics.user.lastChangedBy: true
      Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      Lastchangedat
}
