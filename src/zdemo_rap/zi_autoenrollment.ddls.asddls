@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'AutoPay Enrollment Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_AUTOENROLLMENT
  as select from zautopay_hdr
  composition [0..*] of ZI_AUTOBANK as _Bank
{
  key uuid              as Uuid,
      businesspartner   as Businesspartner,
      contractaccount   as Contractaccount,
      eligible          as Eligible,
      eligibility_msg   as EligibilityMsg,
      enrollment_status as EnrollmentStatus,
      entity            as Entity,
      createdby         as Createdby,
      createdat         as Createdat,
      lastchangedat     as Lastchangedat,
      _Bank
}
