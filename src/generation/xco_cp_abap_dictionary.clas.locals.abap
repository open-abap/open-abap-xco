CLASS lcl_dbt_field_content DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_xco_database_table_field_ct.

    METHODS constructor
      IMPORTING
        iv_key_indicator TYPE abap_bool.

  PRIVATE SECTION.
    DATA mv_key_indicator TYPE abap_bool.
ENDCLASS.

CLASS lcl_dbt_field DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_xco_database_table_field.

    METHODS constructor
      IMPORTING
        iv_name          TYPE sxco_ad_field_name
        iv_key_indicator TYPE abap_bool.

  PRIVATE SECTION.
    DATA mo_content TYPE REF TO if_xco_database_table_field_ct.
ENDCLASS.

CLASS lcl_dbt_fields DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_xco_dbt_fields.

    METHODS constructor
      IMPORTING
        iv_table_name TYPE sxco_dbt_object_name
        iv_key_only   TYPE abap_bool.

  PRIVATE SECTION.
    DATA mv_table_name TYPE sxco_dbt_object_name.
    DATA mv_key_only TYPE abap_bool.
ENDCLASS.

CLASS lcl_dbt_fields_factory DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_xco_dbt_fields_factory.

    METHODS constructor
      IMPORTING
        iv_table_name TYPE sxco_dbt_object_name.
ENDCLASS.

CLASS lcl_database_table DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_xco_database_table.

    METHODS constructor
      IMPORTING
        iv_name TYPE sxco_dbt_object_name.
ENDCLASS.

CLASS lcl_dbt_field_content IMPLEMENTATION.
  METHOD constructor.
    mv_key_indicator = iv_key_indicator.
  ENDMETHOD.

  METHOD if_xco_database_table_field_ct~get.
    rs_content-key_indicator = mv_key_indicator.
  ENDMETHOD.

  METHOD if_xco_database_table_field_ct~get_type.
    CLEAR ro_type.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_dbt_field IMPLEMENTATION.
  METHOD constructor.
    if_xco_database_table_field~name = iv_name.
    mo_content = NEW lcl_dbt_field_content( iv_key_indicator ).
  ENDMETHOD.

  METHOD if_xco_database_table_field~content.
    ro_content = mo_content.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_dbt_fields IMPLEMENTATION.
  METHOD constructor.
    mv_table_name = iv_table_name.
    mv_key_only = iv_key_only.
  ENDMETHOD.

  METHOD if_xco_dbt_fields~get_names.
    DATA lv_workaround TYPE string VALUE 'DDFIELDS'.
    DATA lr_ddfields TYPE REF TO data.
    FIELD-SYMBOLS <lt_ddfields> TYPE ANY TABLE.
    FIELD-SYMBOLS <ls_ddfield> TYPE any.
    FIELD-SYMBOLS <lv_component> TYPE any.

    CREATE DATA lr_ddfields TYPE (lv_workaround).
    ASSIGN lr_ddfields->* TO <lt_ddfields>.
    ASSERT sy-subrc = 0.

    <lt_ddfields> = CAST cl_abap_structdescr(
      cl_abap_typedescr=>describe_by_name( mv_table_name ) )->get_ddic_field_list( ).

    LOOP AT <lt_ddfields> ASSIGNING <ls_ddfield>.
      IF mv_key_only = abap_true.
        ASSIGN COMPONENT 'KEYFLAG' OF STRUCTURE <ls_ddfield> TO <lv_component>.
        IF sy-subrc <> 0 OR <lv_component> <> abap_true.
          CONTINUE.
        ENDIF.
      ENDIF.

      ASSIGN COMPONENT 'FIELDNAME' OF STRUCTURE <ls_ddfield> TO <lv_component>.
      ASSERT sy-subrc = 0.
      APPEND <lv_component> TO rt_names.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_dbt_fields_factory IMPLEMENTATION.
  METHOD constructor.
    if_xco_dbt_fields_factory~all = NEW lcl_dbt_fields(
      iv_table_name = iv_table_name
      iv_key_only   = abap_false ).
    if_xco_dbt_fields_factory~key = NEW lcl_dbt_fields(
      iv_table_name = iv_table_name
      iv_key_only   = abap_true ).
  ENDMETHOD.

  METHOD if_xco_dbt_fields_factory~get.
    DATA(lt_key_names) = if_xco_dbt_fields_factory~key->get_names( ).

    LOOP AT if_xco_dbt_fields_factory~all->get_names( ) INTO DATA(lv_name).
      DATA(lv_key_indicator) = xsdbool( line_exists( lt_key_names[ table_line = lv_name ] ) ).
      APPEND NEW lcl_dbt_field(
        iv_name          = lv_name
        iv_key_indicator = lv_key_indicator ) TO rt_fields.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_database_table IMPLEMENTATION.
  METHOD constructor.
    if_xco_ar_object~name = iv_name.
    if_xco_database_table~fields = NEW lcl_dbt_fields_factory( iv_name ).
  ENDMETHOD.

  METHOD if_xco_ar_object~exists.
    CLEAR rv_exists.
  ENDMETHOD.

  METHOD if_xco_ar_object~get_namespace.
    CLEAR rv_namespace.
  ENDMETHOD.

  METHOD if_xco_ar_object~get_package.
    CLEAR ro_package.
  ENDMETHOD.

  METHOD if_xco_ar_object~get_original_language.
    CLEAR ro_original_language.
  ENDMETHOD.

  METHOD if_xco_ar_object~get_state.
    CLEAR ro_state.
  ENDMETHOD.

  METHOD if_xco_cts_changeable~get_object.
    CLEAR ro_object.
  ENDMETHOD.

  METHOD if_xco_database_table~content.
    CLEAR ro_content.
  ENDMETHOD.
ENDCLASS.
