INTERFACE if_xco_cds_view PUBLIC.

  INTERFACES if_xco_ar_object.

  ALIASES exists FOR if_xco_ar_object~exists.
  ALIASES name FOR if_xco_ar_object~name.

  DATA fields TYPE REF TO if_xco_cds_fields_factory READ-ONLY.
  DATA associations TYPE REF TO if_xco_cds_associations_fctry READ-ONLY.
  DATA compositions TYPE REF TO if_xco_cds_compositions_fctry READ-ONLY.
  DATA parameters   TYPE REF TO if_xco_cds_parameters_fctry READ-ONLY.

ENDINTERFACE.
