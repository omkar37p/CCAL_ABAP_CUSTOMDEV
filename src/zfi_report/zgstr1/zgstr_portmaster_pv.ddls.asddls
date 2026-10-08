@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Port Master Projection View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZGSTR_PORTMASTER_PV  
provider contract transactional_query 
  as projection on ZGSTR_PORTMASTER_RE
{
    key Portname,
    key Countryname,
    Portno,
    Portofloading,
    Portofclearance
   
}
