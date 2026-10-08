@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Department User - Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP01_RV1
  as select from zmm_app01_tb3
{
  key prodgrp     as Prodgrp,
  key exprdgrp    as Exprdgrp,
      prodgrpname as Prodgrpname,
      exgrpname   as Exgrpname


}
