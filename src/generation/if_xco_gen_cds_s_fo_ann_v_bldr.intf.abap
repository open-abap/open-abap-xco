INTERFACE if_xco_gen_cds_s_fo_ann_v_bldr PUBLIC.
  INTERFACES if_xco_gen_cds_s_fo_ann_value.

  ALIASES build        FOR if_xco_gen_cds_s_fo_ann_value~build.
  ALIASES add_string   FOR if_xco_gen_cds_s_fo_ann_value~add_string.
  ALIASES add_enum     FOR if_xco_gen_cds_s_fo_ann_value~add_enum.
  ALIASES add_boolean  FOR if_xco_gen_cds_s_fo_ann_value~add_boolean.
  ALIASES add_number   FOR if_xco_gen_cds_s_fo_ann_value~add_number.
  ALIASES add_member   FOR if_xco_gen_cds_s_fo_ann_value~add_member.
  ALIASES begin_array  FOR if_xco_gen_cds_s_fo_ann_value~begin_array.
  ALIASES end_array    FOR if_xco_gen_cds_s_fo_ann_value~end_array.
  ALIASES begin_record FOR if_xco_gen_cds_s_fo_ann_value~begin_record.
  ALIASES end_record   FOR if_xco_gen_cds_s_fo_ann_value~end_record.
ENDINTERFACE.
