CLASS cl_xco_cds_annotation DEFINITION PUBLIC FINAL CREATE PUBLIC.
* an annotation and its value, the value is the same object
  PUBLIC SECTION.
    INTERFACES if_xco_cds_annotation.
    INTERFACES if_xco_cds_annotation_value.

* iv_json: the value as JSON, see cl_xco_runtime_ddic=>ty_annotation
    METHODS constructor
      IMPORTING
        iv_json TYPE string.

  PRIVATE SECTION.
    DATA mv_json TYPE string.
ENDCLASS.

CLASS cl_xco_cds_annotation IMPLEMENTATION.
  METHOD constructor.
    mv_json = iv_json.
  ENDMETHOD.

  METHOD if_xco_cds_annotation~get_value.
    ro_value = me.
  ENDMETHOD.

  METHOD if_xco_cds_annotation_value~write_to.
* scalars to elementary data, arrays to internal tables, objects to structures by component name
    xco_cp_json=>data->from_string( mv_json )->write_to( ir_data ).
  ENDMETHOD.
ENDCLASS.
